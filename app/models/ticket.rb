class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :relationships, foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :relationships, source: :follower
  before_create :create_activation_digest
  mount_uploader :picture, PictureUploader
  attr_accessor :user_attributes, :activation_token
  default_scope -> { order(updated_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 70 }
  validates :content, presence: true, length: { maximum: 4096 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :ticket_type, presence: true
  validates :location, length: { maximum: 50 }, presence: true
  validate :picture_size
  validate :not_main_category

  def not_main_category
    if self.category.main?
      errors.add(:category_id, "should choose subcategory")
    end
  end
  
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end
  
  def find_next(up_at, cat_id)
    Ticket.where("updated_at < ? and category_id = ? ", up_at, cat_id).first || nil
  end

  def find_previous(up_at, cat_id)
    Ticket.where("updated_at > ? and category_id = ? ", up_at, cat_id).last || nil
  end

  def Ticket.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Ticket.new_token
    SecureRandom.urlsafe_base64
  end

  def authenticated?(activation_token)
    digest = send("activation_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(activation_token)
  end

  def send_activation_email
    TicketMailer.ticket_activation(self).deliver_now
  end

  def activate
    update_attributes(activated: true, activated_at: Time.zone.now)
  end

  private

    def create_activation_digest
      self.activation_token = Ticket.new_token
      self.activation_digest = Ticket.digest(activation_token)
    end
end
