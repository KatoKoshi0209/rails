class Administrator::ShiftsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin!

  def index
    # 翌月の年と月を取得
    selected_year = params[:year] || (Date.today.next_month.year)
    selected_month = params[:month] || Date.today.next_month.month
    
    # 開始日と終了日を設定
    start_date = Date.new(selected_year.to_i, selected_month.to_i, 1)
    end_date = start_date.end_of_month
  
    # シフトを月ごとに集計
    @shifts = Shift.where(date: start_date..end_date)
  
    # ユーザーごとにシフト勤務時間を計算
    @user_shifts = @shifts.group_by(&:user)
  
    # 各ユーザーの予定勤務時間と予定給与を計算
    @user_schedules = @user_shifts.map do |user, shifts|
      total_hours = shifts.sum { |shift| (shift.end_time - shift.start_time) / 1.hour } # 勤務時間の合計
      hourly_wage = user.hourly_wage || 1200 # 時給（もし空ならデフォルトで1200円）
      total_salary = total_hours * hourly_wage # 予定給与
      { user: user, total_hours: total_hours, total_salary: total_salary }
    end
  
    # 月ごとの予定給与合計を計算
    @total_monthly_salary = @user_schedules.sum { |schedule| schedule[:total_salary] }
  end
  

  def new
    @shift = Shift.new
    if params[:date]
      @shift.date = params[:date] # URLパラメータからシフト日を設定
      @shift_date = Date.parse(params[:date])
      @shift_requests = ShiftRequest.where("DATE(date) = ?", @shift_date)
    end
  end   

  def create
    @shift = Shift.new(shift_params)
    if @shift.save
      redirect_to administrator_shifts_path, notice: 'シフトが作成されました。'
    else
      render :new
    end
  end

  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy
    redirect_to administrator_shifts_path, alert: 'シフトが削除されました。'
  end

  # シフトの編集画面を表示
  def edit
    @shift = Shift.find(params[:id])
  end

  # シフトの更新
  def update
    @shift = Shift.find(params[:id])
    if @shift.update(shift_params)
      redirect_to administrator_shifts_path, notice: 'シフトが更新されました。'
    else
      render :edit
    end
  end

  private

  def authorize_admin!
    redirect_to root_path, alert: "権限がありません。" unless current_user.administrator?
  end

  def shift_params
    params.require(:shift).permit(:date, :start_time, :end_time, :user_id) # 必要に応じてフィールドを追加
  end
end
