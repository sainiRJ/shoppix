class CoursesContentsController < ApplicationController
    before_action :set_course
  
    def new
      @course_content = CourseContent.new
    end
  
    def create
      @course_content = @course.course_contents.build(course_content_params)
      if @course_content.save
        @course_content.content_url = url_for(@course_content.video_file)
        @course_content.content_type = url_for(@course_content.file)
        @course_content.save
        redirect_to course_index_path
      else
        render 'new'
      end
    end
  
    # Add other actions like edit, update, and destroy as needed.
  
    private
  
    def set_course
      id= session[:name]
      @course = Course.find_by(id:id)
      session.delete(:id)
    end
  
    def course_content_params
      params.require(:course_content).permit(:title, :file, :video_file)
    end
  end
  