class LessionLogsController < ApplicationController
  def show

  end

  def create
    @lession_log = Lession_log.create user_id: current_user[:id],
      lession_id: params[:id]
    redirect_to create_question_log_path(@lession_log)
  end
end
