class LessonsController < ApplicationController
  before_action :find_lesson, only: %i(edit update destroy)

  def new
    @lesson = lesson.new
  end

  def create
    @lesson = lesson.new lesson_params
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
    @lessons = lesson.all.page(params[:page]).per_page Settings.data.pages
  end

  def destroy
    if @lesson.destroy
      flash[:success] = t ".delete"
      redirect_to lessons_url
    else
      flash[:danger] = t "danger"
      redirect_to home_path
    end
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

  private

  attr_reader :lesson

  def lesson_params
    params.require(:lesson).permit lesson::lesson_ATTRS
  end

  def find_lesson
    @lesson = lesson.find_by id: params[:id]
    return if @lesson
    redirect_to root_path
  end
end
