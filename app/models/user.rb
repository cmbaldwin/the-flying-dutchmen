class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include Fora::ForumUser

  has_one_attached :avatar

  validates :username, uniqueness: { case_sensitive: false }
  validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
                     file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }

  def name
    username.nil? ? email : username
  end

  def auto_subscribe
    settings&.dig('auto_subscribe')&.to_i&.zero? || false
  end

  def new_window
    settings&.dig('new_window')&.to_i&.zero? || false
  end
end
