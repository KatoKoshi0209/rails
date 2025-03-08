class AttendancesController < ApplicationController
  def new
    @attendance = Attendance.new
    user_id = current_user.id
    today = Date.today
    # 変数名を改善し、attendance_timeが今日の日付で一致するレコードを取得
    @attendance_record = Attendance.find_by(user_id: user_id, attendance_time: today.beginning_of_day..today.end_of_day) || Attendance.new(id: -1)
  end

  def create
    user_id = current_user.id
    today = Time.zone.today
  
    # 本日すでに出勤記録があるか確認
    existing_attendance = Attendance.find_by(user_id: user_id, attendance_time: today.beginning_of_day..today.end_of_day)
  
    if existing_attendance
      flash[:alert] = "本日はすでに出勤済みです！"
      redirect_to request.referer
      return
    end
  
    @attendance = Attendance.new(attendance_params)
    @attendance.user_id = user_id
    @attendance.attendance_time = @attendance.attendance_time.in_time_zone('Asia/Tokyo')
  
    if @attendance.save
      now = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')
      flash[:notice] = "出勤しました: #{now}" 
      redirect_to request.referer
    else
      render :new
    end
  end

  def update
    user_id = current_user.id
    today = Time.zone.today
  
    # 今日の出勤記録を取得
    attendance = Attendance.find_by(user_id: user_id, attendance_time: today.beginning_of_day..today.end_of_day)
  
    # 出勤していない場合は処理を拒否
    if attendance.nil?
      flash[:alert] = "本日はまだ出勤していません！"
      redirect_to request.referer
      return
    end
  
    # すでに退勤済みなら処理を拒否
    if attendance.leave_time.present?
      flash[:alert] = "本日はすでに退勤済みです！"
      redirect_to request.referer
      return
    end
  
    now = Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')

    if attendance.break_end_time.present?
      flash[:alert] = "休憩が終了しているため、休憩を開始できません。"
      redirect_to request.referer
      return
    end
  
    if params[:attendance][:break_start_time].present?
      # 休憩開始
      attendance.update(break_start_time: Time.zone.now)
      flash[:notice] = "休憩を開始しました: #{now}"
    elsif params[:attendance][:break_end_time].present?
      # 休憩開始していない場合はエラー
      if attendance.break_start_time.nil?
        flash[:alert] = "休憩を開始していません！"
        redirect_to request.referer
        return
      end
      # 休憩終了
      attendance.update(break_end_time: Time.zone.now)
      flash[:notice] = "休憩を終了しました: #{now}"
    elsif params[:attendance][:leave_time].present?
      # 休憩開始していて、かつ休憩終了していない場合は退勤不可
      if attendance.break_start_time.present? && attendance.break_end_time.nil?
        flash[:alert] = "休憩終了していません！"
        redirect_to request.referer
        return
      end
      # 退勤
      attendance.update(leave_time: Time.zone.now)
      flash[:notice] = "退勤しました: #{now}"
    end
    redirect_to request.referer
  end

  def index
  end

  def show
  end

  private
  
  def attendance_params
    params.require(:attendance).permit(:user_id, :attendance_time, :break_start_time, :break_end_time, :leave_time)
  end
end
