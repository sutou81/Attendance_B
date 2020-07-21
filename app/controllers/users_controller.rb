class UsersController < ApplicationController
  before_action :set_one_month, only: :show
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end
  
  def show
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
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'ユーザー情報を更新しました'
      redirect_to user_url(@user)
    else
      render :edit
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_cofirmation)
    end
    
  # beforeフィルター(logged_in_user, correct_user→sessions_helper.rbにあり)
  
  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
end
