class EnrollmentsController < ApplicationController
  before_action :set_course

  # POST /courses/:course_title/enrollments
  def create
    @enrollment = Enrollment.new(user: current_user, course: @course, enrollment_date: Time.current, completed: false, active_lesson: 1)

    if @enrollment.save
      first_lesson = @enrollment.course.lessons.order(order_rank: :asc).first
      current_user.user_progresses.create(
        lesson: first_lesson,
        score: 0,
        current_step: 1,
        completed: false
      )
      add_coins(10)
      redirect_to first_lesson
    else
      redirect_to @course
    end
  end

  private

  def set_course
    @course = Course.find_by(title: params[:course_title])
    return redirect_to courses_path, alert: 'Course not found.' unless @course
  end

  def add_coins(amount)
    @current_user.increment!(:coins, amount)
  end
end
