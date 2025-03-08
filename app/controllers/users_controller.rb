class UsersController < ApplicationController
  def show
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to attendance_path
    else
      render "users/edit"
    end
  end

end
