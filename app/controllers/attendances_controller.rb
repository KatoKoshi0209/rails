class AttendancesController < ApplicationController
  def create
  end

  def update
  end

  def index
  end

  def show
  end

  private
  
  def attendance_params
    params.permit(:user_id, :attendance_time, :break_start_time, :break_end_time, :leave_time)
  end
end
