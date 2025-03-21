class LocationSettingsController < ApplicationController
  before_action :set_location, only: [:edit, :update]

  def index
    @location_settings = LocationSetting.all
  end

  def new
    @location_setting = LocationSetting.new
  end

  def create
    @location_setting = LocationSetting.new(location_setting_params)
    if @location_setting.save
      redirect_to location_settings_path, notice: '位置情報を登録しました。'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @location_setting.update(location_setting_params)
      redirect_to location_settings_path, notice: '位置情報を更新しました。'
    else
      render :edit
    end
  end

  private

  def set_location
    @location_setting = LocationSetting.find(params[:id])
  end

  def location_setting_params
    params.require(:location_setting).permit(:office_name, :latitude, :longitude, :radius, :use_location_check)
  end
end
