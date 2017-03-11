class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :tickets, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :relationships, source: :followed
  validates :name, length: { maximum: 50 }, presence: true, allow_nil: true
  validates :name, presence: true, if: :validate_name?
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, length: { maximum: 225 },
                    format: { with: VALID_EMAIL_REGEX }
  validates :phone, length: { maximum: 15 }
  attr_accessor :validate_name

  def validate_name?
    validate_name == 'true' || validate_name == true
  end

  def follow(ticket)
    following << ticket
  end

  def unfollow(ticket)
    following.delete(ticket)
  end

  def following?(ticket)
    following.include?(ticket)
  end
end
