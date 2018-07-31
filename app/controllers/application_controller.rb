class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  before_action :set_locale
  before_action :is_admin?

  def logged_in_user
    return if logged_in?
    flash[:danger] = t "log_in"
    redirect_to login_path
  end

  def is_admin?
    return if logged_in_user
    return if current_user.admin?
    flash[:danger] = t "admin_access"
    redirect_to root_path
  end

  def get_using_records obj, flag
    obj.using(flag).page(params[:page]).per_page Settings.data.pages
  end

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
