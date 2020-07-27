class UsersController < ApplicationController
  before_action :set_one_month, only: :show
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :edit_basic_info, :update_basic_info]
  before_action :correct_user, only: [:edit, :update]
  before_action :show_access_limit, only: :show
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  
  def new
    @user = User.new
  end
  
  def index
    @user = User.paginate(page: params[:page]).search(params[:search])
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
  
  def destroy
    @user.delete
    flash[:success] = "#{@user.name}のデータを削除しました"
    redirect_to users_url
  end
  
  def edit_basic_info
    @user = User.find(params[:id])
  end
  
  # @user.errors.full_messagesは配列のため、joinメソッドを使って要素ごとに「、」で区切るよう指定しています。これでひとまず更新失敗時に動作するはずです。
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_cofirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:department, :basic_time, :work_time)
    end
    
  # beforeフィルター(logged_in_user, correct_user→sessions_helper.rbにあり)
  
  # paramsハッシュからユーザーを取得します。
  def set_user
    @user = User.find(params[:id])
  end
end
