class CourseContent < ApplicationRecord
  has_one_attached :video_file
  attribute :content_url, :string
  has_one_attached :file
  attribute :content_type, :string
  belongs_to :course
end
