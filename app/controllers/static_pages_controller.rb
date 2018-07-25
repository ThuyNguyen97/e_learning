class StaticPagesController < ApplicationController
  skip_before_action :is_admin?

  def home
    @categories = Category.includes(:courses).select :id, :name, :description
    return unless logged_in?
    @courses = Course.includes(:lessons).select :id, :name
    lesson_logs = current_user.lesson_logs.order_date(:desc).includes :lesson
    @lesson_logs = lesson_logs.paginate page: params[:page],
      per_page: Settings.data.pages
    @results = LessonLog.get_results @lesson_logs
  end
end
