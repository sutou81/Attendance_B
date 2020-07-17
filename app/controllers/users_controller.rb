class UsersController < ApplicationController
  before_action :set_one_month, only: :show
  
  
  def new
    @user = User.new
  end
  
  def show
    @user = User.find(params[:id])
    
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "新規作成しました。"
      redirect_to @user # ←はredirect_to user_url(@user)と同等→ @userの意味するところ：user.id
    else
      render :new
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_cofirmation)
    end
end
