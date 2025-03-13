class ShiftsController < ApplicationController
  before_action :authenticate_user!

  def index
    # 年月の取得
    @year = params[:year] || Date.today.year
    @month = params[:month] || Date.today.month
  
    # 開始日と終了日を設定
    @start_date = Date.new(@year.to_i, @month.to_i, 1)
    @end_date = @start_date.end_of_month
  
    # 選択された月のシフトを取得
    @shifts = Shift.where(date: @start_date..@end_date)
    @user_shifts = Shift.where(date: @start_date..@end_date, user: current_user)
  
    # 月間予定給与合計を計算
    @total_monthly_salary = @user_shifts.sum do |shift|
      hourly_wage = shift.user.hourly_wage || 1200  # 時給（デフォルト1200円）
      total_hours = ((shift.end_time - shift.start_time) / 1.hour).floor  # 勤務時間の計算（小数点以下切り捨て）
      total_hours * hourly_wage  # その日の給与合計
    end
  
    # 月間勤務時間合計を計算
    @total_monthly_hours = 0
    @total_monthly_minutes = 0
  
    @user_shifts.each do |shift|
      total_hours = ((shift.end_time - shift.start_time) / 1.hour).floor  # 勤務時間（時間単位、小数点以下切り捨て）
      total_minutes = (((shift.end_time - shift.start_time) % 1.hour) / 1.minute).floor  # 勤務時間（分単位、小数点以下切り捨て）
  
      # 時間と分を合算
      @total_monthly_hours += total_hours
      @total_monthly_minutes += total_minutes
    end
  
    # 分を時間に変換
    if @total_monthly_minutes >= 60
      extra_hours = @total_monthly_minutes / 60
      @total_monthly_hours += extra_hours
      @total_monthly_minutes = @total_monthly_minutes % 60
    end
  end  
end
