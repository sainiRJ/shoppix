class CreateCourseContents < ActiveRecord::Migration[7.0]
  def change
    create_table :course_contents do |t|
      t.string :title
      t.string :content_type
      t.string :content_url
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
