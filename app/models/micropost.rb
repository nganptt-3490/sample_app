class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [Settings.digits.digit_500,
                                                   Settings.digits.digit_500]
  end

  MICROPOST_PARAMS = %i(content image).freeze

  validates :content, presence: true,
  length: {maximum: Settings.digits.digit_140}
  validates :image, content_type: {in: Settings.image_type,
                                   message: I18n.t("microposts.must_be_valid")},
                  size: {less_than: Settings.digits.ditgit_5.megabytes,
                         message: I18n.t("microposts.less_than_5mb")}

  scope :recent_posts, ->{order created_at: :desc}
end
