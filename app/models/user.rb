class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :tickets, dependent: :destroy
  validates :name, length: { maximum: 50 }, presence: true, allow_nil: true
  validates :name, presence: true, if: :validate_name?
  validates :location, length: { maximum: 50 }, presence: true, allow_nil: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 225 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :phone, length: { maximum: 15 }
  attr_accessor :validate_name

  def validate_name?
    validate_name == 'true' || validate_name == true
  end
end
