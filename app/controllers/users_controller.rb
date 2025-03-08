class UsersController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールを更新しました"
      redirect_to user_path
    else
      render "users/edit"
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :profile_image, :email)
  end

end
