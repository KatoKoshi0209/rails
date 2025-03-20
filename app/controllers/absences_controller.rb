class AbsencesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_absence, only: [:approve, :reject]

  def index
    if current_user.administrator?
      @absences = Absence.includes(:user, :shift).order(created_at: :desc)
    else
      @absences = current_user.absences.includes(:shift).order(created_at: :desc)
    end
  end

  def new
    @absence = current_user.absences.new(shift_id: params[:shift_id])
  end

  def create
    @absence = current_user.absences.new(absence_params)
    if @absence.shift.present?
      @absence.assign_attributes(
        shift_date: @absence.shift.date,
        shift_start_time: @absence.shift.start_time,
        shift_end_time: @absence.shift.end_time
      )
    end
    if @absence.save
      redirect_to absences_path, notice: "欠勤申請を提出しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def approve
    if @absence.update(status: 1) # 承認
      @absence.shift.destroy
      redirect_to absences_path, notice: "欠勤申請を承認しました。"
    else
      redirect_to absences_path, alert: "処理に失敗しました。"
    end
  end

  def reject
    if @absence.update(status: 2) # 却下
      redirect_to absences_path, notice: "欠勤申請を却下しました。"
    else
      redirect_to absences_path, alert: "処理に失敗しました。"
    end
  end

  private

  def set_absence
    @absence = Absence.find(params[:id])
  end

  def absence_params
    params.require(:absence).permit(:shift_id, :status, :absence_reason)
  end
end
