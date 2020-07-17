module SessionsHelper
  # sessionとはログインを維持する機能→その機能する箱の中にuser.idを入れてログインを維持する
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user?
    if session[:user_id] 
      @user = User.find(session[:user_id])
    end
  end
  
  def current_user
     @user = User.find(session[:user_id])
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 現在ログイン中のユーザーがいる場合オブジェクトを返します。
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  
  
    
end
