class Administrator::UsersController < ApplicationController
  before_action :admin_user

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.administrator = false # 新しく作成する従業員はデフォルトで一般従業員

    if @user.save
      redirect_to administrator_users_path, notice: '従業員が作成されました。'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to administrator_users_path, notice: '従業員情報が更新されました。'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :hourly_wage, :administrator)
  end

  def admin_user
    redirect_to root_path unless current_user.administrator?
  end
end
