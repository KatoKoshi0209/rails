class ModificationsController < ApplicationController
  before_action :check_administrator, only: [:approve, :reject]
  def index
    if current_user.administrator?
      @modifications = Modification.order(status: :asc, created_at: :desc)
    else
      @modifications = current_user.modifications.order(status: :asc, created_at: :desc)
    end
  end  

  def approve
    modification = Modification.find(params[:id])
    # modification に関連する attendance を取得
    attendance = modification.attendance
  
    # attendance を修正（modification のデータを反映）
    if attendance.update(
      attendance_time: modification.modify_attendance_time,
      leave_time: modification.modify_leave_time,
      break_start_time: modification.modify_break_start_time,
      break_end_time: modification.modify_break_end_time
    )
      # 修正成功時、modification を承認済みに変更
      modification.update(status: 1)
      redirect_to modifications_path, notice: "修正リクエストを承認しました"
    else
      # 修正失敗時の処理
      redirect_to modifications_path, alert: "修正の承認に失敗しました"
    end
  end  
  
  def reject
    modification = Modification.find(params[:id])
    modification.update(status: 2)  # 却下に変更
    redirect_to modifications_path, alert: "修正リクエストを却下しました"
  end  
  
  def new
    @modification = Modification.new
    if params[:attendance_id]
      attendance = Attendance.find(params[:attendance_id])
      @modification.modify_attendance_time = attendance.attendance_time
      @modification.modify_leave_time = attendance.leave_time
      @modification.modify_break_start_time = attendance.break_start_time
      @modification.modify_break_end_time = attendance.break_end_time
      @modification.user_id = attendance.user_id
      @modification.attendance_id = attendance.id
    end
  end

  def create
    @modification = Modification.new(modification_params)
    @modification.user_id = current_user.id
    if @modification.save
      redirect_to attendances_path, notice: "修正依頼を送信しました。"
    else
      Rails.logger.debug @modification.errors.full_messages.join(", ")
      render :new
    end
  end
  
  private
  
  def modification_params
    params.require(:modification).permit(:modify_attendance_time, :modify_leave_time, :modify_break_start_time, :modify_break_end_time, :modify_reason, :user_id, :attendance_id)
  end

  def check_administrator
    redirect_to root_path unless current_user.administrator?
  end
end
