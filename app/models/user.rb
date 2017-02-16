class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, length: { maximum: 50 }, presence: true, allow_nil: true
  validates :location, length: { maximum: 50 }, presence: true, allow_nil: true 
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 225 }, 
                    format: { with: VALID_EMAIL_REGEX }
  validates :phone, length: { maximum: 15 }

end
