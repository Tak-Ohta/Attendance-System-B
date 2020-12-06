class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update]
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :index
  
  def new
    @user = User.new
  end
  
  def show
  end
  
  def index
    @users = User.paginate(page: params[:page], per_page: 20)
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user # 保存成功後、ログインする
      flash[:success] = "新規作成に成功しました。"
      redirect_to @user
    else
      flash.now[:danger] = "新規登録に失敗しました。" # renderの場合、flash.now
      render :new
    end     
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報を更新しました。"
      redirect_to @user
    else
      flash.now[:danger] = "更新に失敗しました。"
      render :edit
    end
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
    
    # ログイン済みのユーザーか確認する
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    # アクセスしたユーザーIDが現在ログインしているユーザーか確認する
    def correct_user
      redirect_to root_url unless current_user?(@user)
    end
    
    # 管理者権限を有しているか判定する
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end