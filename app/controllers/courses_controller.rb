class CoursesController < ApplicationController
    before_action :authenticate_instructor, only: [:new, :create]
    def new
      @course = Course.new
    end
  
    def create
        @course = @current_instructor.courses.build(course_params)
      if @course.save
        name = @course.name
        session[:name] = Course.find_by(name:name).id
        
        redirect_to content_new_path
      else
        render 'new'
      end
    end
  
    def index
      @course = Course.all
    end

    def show
      @course = Course.find(params[:id])
      
    end

    private
  
    def course_params
      params.require(:course).permit(:name, :description, :price)
    end

    def authenticate_instructor
      token = session[:token]
      verify = ::JsonWebToken.decode(token)
      id = verify['instructor_id']
      @current_instructor = Instructor.find_by(id: id)
    end
end
  