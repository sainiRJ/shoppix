class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.text :description
      t.decimal :price
      t.references :instructor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
