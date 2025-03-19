class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:sign_in]
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    if current_user.administrator?
      flash[:notice] = "管理者ユーザーとしてログインしました。"
      summary_administrator_user_attendances_path(current_user) # 管理者なら、administrator_users_pathにリダイレクト
    else
      new_attendance_path
    end
  end

  def after_sign_out_path_for(resource)
    new_user_session_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:hourly_wage])
  end
end
