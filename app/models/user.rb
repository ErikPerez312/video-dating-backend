class User < ApplicationRecord
  validates :name, presence: true
  validates :age, presence: true
  validates :phone_number, presence: true, uniqueness: true
end
