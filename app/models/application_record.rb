class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :using, ->(flag){where used: flag}

  def destroy_actions lesson_logs, act
    if act.eql? I18n.t("delete")
      do_destroy lesson_logs
    else
      update_attributes used: !used
      I18n.t("warning")
    end
  end

  def do_destroy lesson_logs
    if LessonLog.valid_to_destroy lesson_logs
      destroy
      return I18n.t("success")
    end
    I18n.t("danger")
  end
end
