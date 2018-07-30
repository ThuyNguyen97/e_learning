class FiltersController < ApplicationController
  before_action :logged_in_user,
    only: %i(listword listwordcategory listwordalphabet listword_learned)
  skip_before_action :is_admin?

  def listword
    @answers = paginate Answer.where correct: Settings.number.one
  end

  def listword_category
    @category = Category.find_by id: params[:id]
    @answers = paginate @category.answers.where correct: true
  end

  def listword_alphabet
    @answers = paginate Answer.where(correct: Settings.number.one).order "content ASC"
  end

  def listword_learned
    @status = params[:status]
    @lesson_logs = LessonLog.where user_id: current_user.id

    @question_logs = []
    @lesson_logs.each do |lesson_log|
      @question_logs.push QuestionLog.where lesson_log_id: lesson_log.id
    end

    @learned = []
    @answer = []
    @question_logs.each do |question_log|
      question_log.each do |ql|
        @answer.push Answer.where id: ql.answer_id
      end
    end

    @answer_true = []
    @answer.each do |a|
      @answer_true.push a if a[0].correct
    end

    @arr = []
    @arr = @answer_true.flatten.uniq
    @arr = Kaminari.paginate_array(@arr).page(params[:page]).
      per Settings.data.pages

    @unlearned = []
    return unless @status == Settings.status_unlearn
    @unlearned.push Answer.where.not id: @arr
    @unlearned = Kaminari.paginate_array(@unlearned.first).
      page(params[:page]).per Settings.data.pages
  end

  private
  
  def paginate obj
    obj.page(params[:page]).per_page Settings.data.pages
  end
end
