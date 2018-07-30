class LessonsController < ApplicationController
  before_action :find_lesson, only: %i(edit update destroy)

  def new
    @lesson = Lesson.new
  end

  def create
    @lesson = Lesson.new lesson_params
    if @lesson.save
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def edit; end

  def index
    @lessons = get_using_records Lesson, true
  end

  def destroy
    flash[:warning] = lesson.destroy_actions lesson.get_lesson_logs,
      params[:do]
    redirect_back fallback_location: root_path
  end

  def update
    if @lesson.update_attributes lesson_params
      flash[:success] = t ".success"
      redirect_to lessons_path
    else
      flash[:danger] = t "danger"
      redirect_to root_path
    end
  end

  def restore
    @lessons = get_using_records Lesson, false
  end

  private

  attr_reader :lesson

  def lesson_params
    params.require(:lesson).permit Lesson::LESSON_ATTRS
  end

  def find_lesson
    @lesson = Lesson.find_by id: params[:id]
    return if @lesson
    redirect_to root_path
  end
end
