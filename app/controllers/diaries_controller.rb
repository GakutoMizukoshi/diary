class DiariesController < ApplicationController
  before_action :require_user_logged_in
  
  def new
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    @diary.send_id = params[:send_id]
    if @diary.save
      flash[:warning] = '日記を更新しました。'
      redirect_to diaries_user_path(@diary.send_id)
    else
      @diaries = current_user.diaries.order('created_at DESC').page(params[:page])
      flash.now[:warning] = '日記の更新に失敗しました。'
      render :new
    end
  end
  
  private

  def diary_params
    params.require(:diary).permit(:content)
  end
  
  def the_two_diaries(sender, receiver)
    sender.diaries.where(send_id: receiver.id) + receiver.diaries.where(send_id: sender.id).order('created_at DESC').page(params[:page])
  end

  def debug_params
    puts "********begin************"
    p params
    puts "********end**************"
  end
end
