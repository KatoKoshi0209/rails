class Administrator::ShiftRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  # シフト希望一覧
  def index
    @shift_requests = ShiftRequest.includes(:user).order(date: :asc) # 日付順にソート
  end

  private

  # 管理者チェック（必要に応じて）
  def authenticate_admin!
    redirect_to root_path, alert: '管理者権限が必要です' unless current_user.administrator?
  end
end
