class Instructor < ApplicationRecord
    has_many :courses
    has_secure_password

    validates :full_name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@[^@\s]+\z/ }
    validates :mobile_number, presence: true
end
