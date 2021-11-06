class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include Fora::ForumUser
  
  has_one_attached :avatar
  serialize :settings

  validates :username, uniqueness: { case_sensitive: false }
  validates :avatar, file_size: { less_than_or_equal_to: 5.megabytes },
              file_content_type: { allow: ['image/jpeg', 'image/png', 'image/gif'] }

  def name
    username.nil? ? email : username
  end

  def auto_subscribe
    settings.nil? ? false : !settings["auto_subscribe"].to_i.zero?
  end

  def new_window
    settings.nil? ? false : !settings["new_window"].to_i.zero?
  end

end
