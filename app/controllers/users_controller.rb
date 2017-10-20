class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show]
  
  def index
    @users = User.all.page(params[:page])
  end
  
  def show
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    @followers = @user.followers.page(params[:page])
    p followings_followers_ids = @user.followings.pluck(:id) + @user.followers.pluck(:id).group_by{|i| i}.reject{|k,v| v.one?}.keys
    @followings_followers = User.where(id: followings_followers_ids).page(params[:page])
    @last_diary = Diary.where(id: the_two_diaries(current_user, @user).pluck(:id)).order('updated_at DESC').first
    @diaries = Diary.where(id: the_two_diaries(current_user, @user).pluck(:id)).order('created_at DESC')
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:warning] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:warning] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:warning] = 'プロフィールを更新しました'
      redirect_to @user
    else
      flash.now[:warning] = 'プロフィールの更新に失敗しました。'
      render :edit
    end
  end
  
  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
  end
  
  def diaries
    @user = User.find(params[:id])
    @diaries = Diary.where(id: the_two_diaries(current_user, @user).pluck(:id)).order('created_at DESC')
  end
  
  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  
  def the_two_diaries(sender, receiver)
    sender.diaries.where(send_id: receiver.id) + receiver.diaries.where(send_id: sender.id).order('created_at DESC').page(params[:page])
  end
end
