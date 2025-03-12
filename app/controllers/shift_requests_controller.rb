class ShiftRequestsController < ApplicationController
  def index
    # 年月を取得、指定されていなければ現在の年月を使用
    @year = params[:year] || Date.today.year
    @month = params[:month] || Date.today.month
    
    # シフト希望を年月でフィルタリング
    @shift_requests = current_user.shift_requests.where(date: Date.new(@year.to_i, @month.to_i, 1)..Date.new(@year.to_i, @month.to_i, -1))
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
