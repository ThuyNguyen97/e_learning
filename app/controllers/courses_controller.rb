class CoursesController < ApplicationController
  before_action :find_course, only: %i(edit update destroy)

  def index
    @courses = get_using_records Course, true
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    if @course.save
      flash[:success] = t ".success"
      redirect_to request.referrer
    else
      flash[:danger] = t "danger"
      render :new
    end
  end

  def edit; end

  def destroy
    flash[:warning] = course.destroy_actions course.get_lesson_logs,
      params[:do]
    redirect_back fallback_location: root_path
  end

  def update
    if @course.update_attributes course_params
      flash[:success] = t ".success"
      redirect_to courses_path
    else
      flash[:danger] = t "danger"
      redirect_to root_path
    end
  end

  def restore
    @courses = get_using_records Course, false
  end

  private

  attr_reader :course

  def course_params
    params.require(:course).permit Course::COURSE_ATTRS
  end

  def find_course
    @course = Course.find_by id: params[:id]
    return if @course
    redirect_to root_path
  end
end
