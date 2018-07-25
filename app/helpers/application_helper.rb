module ApplicationHelper
  def full_title page_title = ""
    base_title = t "e_learning"
    page_title.empty? ? base_title : (page_title + " | " + base_title)
  end

  def active path_now
    if path_now.eql? request.path
      Settings.class_css.active
    else
      return if path_now.eql? root_path
      Settings.class_css.active if path_now.in? request.path
    end
  end

  def get_status lesson_log
    if lesson_log.saved?
      [t(".status0"), Settings.table.status.s0, true]
    elsif lesson_log.pass?
      [t(".status2"), Settings.table.status.s2, false]
    elsif lesson_log.pass.nil?
      [t(".status1"), Settings.table.status.s1, true]
    else
      [t(".status3"), Settings.table.status.s3, false]
    end
  end

  def lesson_log_pass? lesson_log
    lesson_log.pass.nil?
  end

  def decide_question question_logs
    return if lesson_log_pass? question_logs.first.lesson_log
    ql_choose = question_logs.select{|ql| !ql.number.zero?}
    return "uncorrect" if ql_choose.size.zero?
    question_logs.select{|ql| !ql.number.zero?}.each do |ql|
      return "uncorrect" if !ql.answer.correct
    end
    "correct"
  end

  def decide_answer question_log
    return if lesson_log_pass?(question_log.lesson_log) ||
      !question_log.answer.correct
    "glyphicon glyphicon-ok"
  end
end
