class LessionlogsController < ApplicationController
  def index
    if current_user? current_user
      redirect_to root_path
    end
  end
  
  def show
    redirect_to root_path unless current_user
    @flag_pass = (Lessionlog.find_by id: params[:id]).pass
    @questionlogs = Questionlog.where lessionlog_id: params[:id]
    @questions = []
    @answers = []
    @answer_ids = []
    @corrects = []

    @questionlogs.each do |questionlog|
      tmp = questionlog.question
      @questions << tmp.content
      tmp2 = tmp.answers.order "RAND()"
      ans_id = []
      ans = []
      iterator_info tmp2, ans, ans_id, @corrects
      @answer_ids << ans_id
      @answers << ans
    end
  end

  def create
    @lessionlog = Lessionlog.create user_id: current_user[:id],
      lession_id: 1
    @lessionlog.create_lessionlog
    redirect_to "/lessionlogs/#{@lessionlog.id}"
  end

  def update
    @questionlog_ids = params[:questionlog].keys
    @lessionlog = Lessionlog.find_by id: params[:id]

    @questionlog_ids.each do |questionlog_id|
      queslog = Questionlog.find_by id: questionlog_id
      queslog.update_attributes answer_id: params[:questionlog][questionlog_id]
    end

    @lessionlog.update_result @questionlog_ids
    redirect_to root_path
  end

  private

  def iterator_info tmp, ans, ans_id, corrects
    tmp.each do |info|
      ans_id << info.id
      ans << info.content
      corrects << info.id if info.correct == true
    end
  end
end
