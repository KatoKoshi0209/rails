class Administrator::ShiftRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  # シフト希望一覧
  def index
    # 年月を取得（デフォルトは翌月）
    @selected_year = params[:year] || Date.today.next_month.year
    @selected_month = params[:month] || Date.today.next_month.month

    # シフト希望を年月でフィルタリング
    @shift_requests = ShiftRequest.includes(:user)
                                  .where(date: Date.new(@selected_year.to_i, @selected_month.to_i, 1)..Date.new(@selected_year.to_i, @selected_month.to_i, -1))
                                  .order(date: :asc) # 日付順にソート
  end

  private

  # 管理者チェック（必要に応じて）
  def authenticate_admin!
    redirect_to root_path, alert: '管理者権限が必要です' unless current_user.administrator?
  end
end
