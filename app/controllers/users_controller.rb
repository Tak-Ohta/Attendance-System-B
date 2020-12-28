class UsersController < ApplicationController
  
  before_action :set_user, only: [:show, :edit, :update, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :index
  before_action :admin_or_correct_user, only: :show
  before_action :set_one_month, only: :show

  
  def new
    @user = User.new
  end
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
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
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to users_url
    else
      flash[:danger] = "更新に失敗しました。やり直してください。"
      render 'edit_basic_info'
    end   
  end


  private
    def user_params
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end

end