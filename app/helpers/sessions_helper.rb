module SessionsHelper
  
  # 引数に渡されたユーザーオブジェクトでログインする
  def log_in(user)
    session[:user_id] = user.id # ブラウザ内にある一時的cookiesに暗号化済みのuser.idが自動で生成される
  end

  # 永続的セッションを記憶する
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 永続セッションを破棄する
  def forget(user)
    user.forget # Userモデルのforgetメソッド
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # セッションと@current_userを破棄する
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # 一時セッションにいるユーザーを返し、それ以外の場合はcookiesに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: session[:user_id])
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 渡されたユーザーがログイン済みのユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end  
  
  # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返す
  # ログインしている状態とは、「一時的セッションにユーザーIDが存在する」こと、同時に、current_userがnilでないこと
  def logged_in?
    !current_user.nil?
  end
  
  # 記憶しているURL（またはデフォルトURL）リダイレクトする
  def redirect_back_or(default_url)
    redirect_to(session[:forwading_url] || default_url)
    session.delete(:forwarding_url)
  end
  
  # アクセスしようとしたURlを記憶する
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
