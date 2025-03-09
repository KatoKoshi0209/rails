class Administrator::AttendancesController < ApplicationController
  before_action :admin_user

  def index
    @user = current_user
    
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
end
