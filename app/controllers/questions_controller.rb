class QuestionsController < ApplicationController
  before_action :find_question, only: %i(edit update destroy)
  before_action :get_all_category, only: %i(new edit)

  def index
    @questions = get_using_records Question, true
  end

  def new
    @question = Question.new
    Settings.number.four.times {@question.answers.new}
  end

  def create
    @question = Question.new question_params
    if @question.save
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def edit; end

  def destroy
    flash[:warning] = question.destroy_actions question.get_lesson_logs,
      params[:do]
    redirect_back fallback_location: root_path
  end

  def update
    if @question.update_attributes question_params
      flash[:success] = t ".success"
      redirect_to questions_path
    else
      flash[:danger] = t "danger"
      redirect_to root_path
    end
  end

  def restore
    @questions = get_using_records Question, false
  end

  private

  attr_reader :question

  def question_params
    params.require(:question).permit Question::QUESTION_ATTRS,
      answers_attributes: Answer::ANSWER_ATTRS
  end

  def find_question
    @question = Question.find_by id: params[:id]
    return if @question
    redirect_to root_path
  end

  def get_all_category
    @categories = Category.all
  end
end
