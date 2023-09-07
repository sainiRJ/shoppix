class Course < ApplicationRecord
  belongs_to :instructor
  has_many :course_contents, dependent: :destroy
  has_many :enrollments, dependent: :destroy
end
