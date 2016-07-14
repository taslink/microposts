class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at: :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      # 保存できなかった時
      render 'new'
    end
  end
  
  def edit
    #before_actionの為削除 @user = User.find(params[:id])
    render 'edit'
  end
  
  def update
    #before_actionの為削除 @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "情報を更新しました。"
      redirect_to @user
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit' , notice: 'アカウントの編集に失敗しました'
    end
  end
  
  def destroy
    @user.destroy
    redirect_to root_path, notice: 'アカウントを削除しました'
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile, :location, :birthday)
  end

 #before_action
  def correct_user
    @user = User.find(params[:id])
    redirect_to root_path unless current_user == @user
  end

end