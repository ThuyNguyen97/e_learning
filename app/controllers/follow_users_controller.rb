class FollowUsersController < ApplicationController
  skip_before_action :is_admin?

  def create
    current_user.follow_users.create follower: params[:id]
    redirect_back fallback_location: root_path
  end

  def destroy
    current_user.follow_users.find_follow(params[:id]).first.destroy
    redirect_back fallback_location: root_path
  end
end