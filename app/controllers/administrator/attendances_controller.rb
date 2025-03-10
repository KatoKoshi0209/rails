class Administrator::AttendancesController < ApplicationController
  before_action :admin_user

  def index
    @user = User.find(params[:user_id])
    
    # 月をパラメータで受け取る (デフォルトは現在月)
    year_month = params[:year_month] || Time.zone.now.strftime("%Y-%m")

    # 年月が正しい形式でない場合はエラー処理を追加
    unless year_month.match(/\A\d{4}-\d{2}\z/)
      flash[:alert] = "正しく年月を選択してください"
      redirect_to attendances_path and return
    end
    year, month = year_month.split('-')

    # 選択された月の勤怠履歴を取得
    start_date = Date.new(year.to_i, month.to_i, 1)
    end_date = start_date.end_of_month

    @attendances = @user.attendances.where(attendance_time: start_date..end_date)

    # 各出勤記録に対して休憩時間と勤務時間を計算
    @attendances_with_times = @attendances.map do |attendance|
      # 勤務時間（出勤時間から退勤時間を引いた差）
      work_time = if attendance.leave_time.present?
                    (attendance.leave_time - attendance.attendance_time)
                  else
                    0
                  end

      # 休憩時間（休憩開始から休憩終了の差）
      break_time = if attendance.break_start_time.present? && attendance.break_end_time.present?
                    (attendance.break_end_time - attendance.break_start_time)
                  else
                    0
                  end

      # 勤務時間を時間と分に変換
      work_hours, work_minutes = convert_to_hours_and_minutes(work_time)
      # 休憩時間を時間と分に変換
      break_hours, break_minutes = convert_to_hours_and_minutes(break_time)

      # 合計勤務時間 = 勤務時間 - 休憩時間
      total_work_time = work_time - break_time
      total_work_hours, total_work_minutes = convert_to_hours_and_minutes(total_work_time)

      # 計算結果を返す
      {
        attendance: attendance,
        work_hours: work_hours,
        work_minutes: work_minutes,
        break_hours: break_hours,
        break_minutes: break_minutes,
        total_work_hours: total_work_hours,
        total_work_minutes: total_work_minutes,
        work_time: work_time,
        break_time: break_time
      }
    end

    # 今月の勤務時間合計を計算
    total_work_time_in_seconds = @attendances_with_times.sum { |data| data[:work_time] } - @attendances_with_times.sum { |data| data[:break_time] }
    @total_work_hours, @total_work_minutes = convert_to_hours_and_minutes(total_work_time_in_seconds)

    @daily_salaries = @attendances_with_times.map do |attendance_data|
      work_hours = attendance_data[:total_work_hours]
      work_minutes = attendance_data[:total_work_minutes] / 60.0
      total_work_hours = work_hours + work_minutes
      daily_salary = @user.hourly_wage * total_work_hours
      { date: attendance_data[:attendance].attendance_time.to_date, salary: daily_salary }
    end

    total_work_time_in_hours = @total_work_hours + @total_work_minutes / 60.0
    @monthly_salary = @user.hourly_wage * total_work_time_in_hours
    
  end

  def summary
    year_month = params[:year_month] || Time.zone.now.strftime("%Y-%m")
    
    unless year_month.match(/\A\d{4}-\d{2}\z/)
      flash[:alert] = "正しく年月を選択してください"
      redirect_to administrator_attendances_path and return
    end
    year, month = year_month.split('-')
    
    start_date = Date.new(year.to_i, month.to_i, 1)
    end_date = start_date.end_of_month
    
    @monthly_salary_per_user = User.includes(:attendances).map do |user|
      total_salary = 0
      total_work_time = 0 # 総勤務時間（秒）
      
      user.attendances.where(attendance_time: start_date..end_date).each do |attendance|
        work_time = attendance.leave_time.present? ? (attendance.leave_time - attendance.attendance_time) : 0
        break_time = (attendance.break_start_time.present? && attendance.break_end_time.present?) ? (attendance.break_end_time - attendance.break_start_time) : 0
        total_work_time_in_seconds = work_time - break_time
        total_work_hours, total_work_minutes = convert_to_hours_and_minutes(total_work_time_in_seconds)
        
        total_salary += user.hourly_wage * (total_work_hours + total_work_minutes / 60.0)
        total_work_time += total_work_time_in_seconds
      end
      
      total_work_hours, total_work_minutes = convert_to_hours_and_minutes(total_work_time)
  
      { user: user, total_salary: total_salary.to_i, total_work_hours: total_work_hours, total_work_minutes: total_work_minutes }
    end
    
    # 給与の多い順に並べ替え
    @monthly_salary_per_user.sort_by! { |data| -data[:total_salary] }
    
    @total_monthly_salary = @monthly_salary_per_user.sum { |data| data[:total_salary] }
    
    # 全体の勤務時間合計
    total_work_time_in_seconds = @monthly_salary_per_user.sum { |data| data[:total_work_hours] * 1.hour + data[:total_work_minutes] * 1.minute }
    @total_work_hours, @total_work_minutes = convert_to_hours_and_minutes(total_work_time_in_seconds)
  end
  
  def edit
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])  # 勤怠情報を取得
  end

  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])  # 更新対象の勤怠情報を取得
    if @attendance.update(attendance_params)
      redirect_to administrator_user_attendances_path, notice: "勤怠情報が更新されました"
    else
      render :edit
    end
  end

  private

  def admin_user
    redirect_to root_path unless current_user.administrator?
  end

  # 時間差を「時間」と「分」に変換するメソッド
  def convert_to_hours_and_minutes(time_in_seconds)
    hours = (time_in_seconds / 1.hour).to_i
    minutes = ((time_in_seconds % 1.hour) / 1.minute).to_i
    return hours, minutes
  end

  def attendance_params
    params.require(:attendance).permit(:attendance_time, :leave_time, :break_start_time, :break_end_time)
  end
end
