class ShiftRequestsController < ApplicationController
  def index
    # 年月を取得、指定されていなければ翌月を使用
    @year = params[:year] || Date.today.next_month.year
    @month = params[:month] || Date.today.next_month.month
  
    # シフト希望を年月でフィルタリング
    @shift_requests = current_user.shift_requests.where(date: Date.new(@year.to_i, @month.to_i, 1)..Date.new(@year.to_i, @month.to_i, -1))
  
    # 合計勤務時間と合計給与の計算（翌月デフォルト）
    total_year = params[:year] || Date.today.next_month.year
    total_month = params[:month] || Date.today.next_month.month
    start_date = Date.new(total_year.to_i, total_month.to_i, 1)
    end_date = start_date.end_of_month
  
    @total_hours = 0
    @total_minutes = 0
    @total_salary = 0
  
    shift_requests = current_user.shift_requests.where(date: start_date..end_date)
    shift_requests.each do |shift|
      if shift.end_time > shift.start_time
        work_hours = ((shift.end_time - shift.start_time) / 1.hour).floor  # 小数点以下切り捨て
        work_minutes = (((shift.end_time - shift.start_time) % 1.hour) / 1.minute).floor  # 小数点以下切り捨て
      else
        work_hours = 0
        work_minutes = 0
      end
  
      # 合計勤務時間（時間と分を別々に加算）
      @total_hours += work_hours
      @total_minutes += work_minutes
  
      # 合計給与
      @total_salary += work_hours * current_user.hourly_wage
    end
  
    # 分を時間に変換（60分を1時間に変換）
    if @total_minutes >= 60
      extra_hours = @total_minutes / 60
      @total_hours += extra_hours
      @total_minutes = @total_minutes % 60
    end
  end
  
  def new
    @shift_request = current_user.shift_requests.new(date: params[:date])
  end

  def create
    @shift_request = current_user.shift_requests.new(shift_request_params)
    if @shift_request.save
      redirect_to shift_requests_path, notice: 'シフト希望を登録しました'
    else
      render :new
    end
  end

  def destroy
    @shift_request = current_user.shift_requests.find(params[:id])
    @shift_request.destroy
    redirect_to shift_requests_path, notice: 'シフト希望を削除しました'
  end

  def edit
    @shift_request = current_user.shift_requests.find(params[:id])
  end

  def update
    @shift_request = current_user.shift_requests.find(params[:id])
  
    # ユーザーのタイムゾーンを使用して時間を変換
    start_time = Time.zone.local(params[:shift_request]["start_time(1i)"].to_i,
                                 params[:shift_request]["start_time(2i)"].to_i,
                                 params[:shift_request]["start_time(3i)"].to_i,
                                 params[:shift_request]["start_time(4i)"].to_i,
                                params[:shift_request]["start_time(5i)"].to_i)
  
    end_time = Time.zone.local(params[:shift_request]["end_time(1i)"].to_i,
                              params[:shift_request]["end_time(2i)"].to_i,
                              params[:shift_request]["end_time(3i)"].to_i,
                              params[:shift_request]["end_time(4i)"].to_i,
                              params[:shift_request]["end_time(5i)"].to_i)
  
    # start_time と end_time をモデルにセット
    @shift_request.start_time = start_time
    @shift_request.end_time = end_time
  
    if @shift_request.save
      redirect_to shift_requests_path, notice: "シフトが更新されました。"
    else
      render :edit, alert: "シフトの更新に失敗しました。"
    end
  end
  

  private

  def shift_request_params
    params.require(:shift_request).permit(:date, :start_time, :end_time)
  end
end
