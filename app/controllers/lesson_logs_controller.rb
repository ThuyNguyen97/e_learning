class LessonLogsController < ApplicationController
  before_action :logged_in_user, only: :show
  before_action :find_lesson_log, only: %i(show update edit finish)
  skip_before_action :is_admin?

  def create
    @lesson_log = LessonLog.create user_id: current_user[:id],
      lesson_id: params[:id]
    @lesson_log.update_attributes spend_time: @lesson_log.updated_at.to_i
    redirect_to edit_lesson_log_path @lesson_log, :id
  end

  def show
    redirect_to root_path unless current_user
    @question_logs = lesson_log.question_logs.preload(:answer)
    @questions, @types = Question.get_questions @question_logs
  end

  def update
    lesson_log.update_attributes spend_time: lesson_log.updated_at.to_i
    lesson_log.update_result params[:commit]
    redirect_to root_path
  end

  def edit
    lesson_log.update_time
    lesson_log.update_attributes saved: false,
      created_at: Time.now if lesson_log.saved
    @question_logs = lesson_log.question_logs.preload :question
    @questions, @types = Question.get_questions @question_logs
  end

  def finish
    lesson_log.update_lesson_log params[:status]
  end

  private

  attr_reader :lesson_log

  def find_lesson_log
    @lesson_log = LessonLog.find_by id: params[:id]
    return if lesson_log
    flash[:danger] = t ".danger"
    redirect_to root_path
  end
end
