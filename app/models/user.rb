class User < ApplicationRecord
  attr_accessor :remember_token

  before_save :downcase_email

  ATTRIBUTE_PERMITTED = %i(name email password password_confirmation).freeze

  validates :name, presence: true, length: {maximum: Settings.name_validate}
  validates :email, presence: true, length: {maximum: Settings.email_validate},
  format: {with: Settings.email_regex}, uniqueness: true
  validates :password, presence: true,
                       length: {minimum: Settings.digits.digit_6},
                       allow_nil: true

  has_secure_password

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string:, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  scope :sorted, -> { order(name: :asc) }

  private

  def downcase_email
    email.downcase!
  end
end
