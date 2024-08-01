class ForumThread < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :forum_category
  belongs_to :user
  has_many :forum_posts, dependent: :destroy
  has_many :forum_subscriptions, dependent: :destroy
  has_many :optin_subscribers, lambda {
                                 where(forum_subscriptions: { subscription_type: :optin })
                               }, through: :forum_subscriptions, source: :user, dependent: :destroy
  has_many :optout_subscribers, lambda {
                                  where(forum_subscriptions: { subscription_type: :optout })
                                }, through: :forum_subscriptions, source: :user, dependent: :destroy

  accepts_nested_attributes_for :forum_posts

  validates :forum_category, presence: true
  validates :user_id, :title, presence: true
  validates_associated :forum_posts

  scope :pinned_first, -> { order(pinned: :desc) }
  scope :solved, -> { where(solved: true) }
  scope :sorted, -> { order(updated_at: :desc) }
  scope :unpinned, -> { where.not(pinned: true) }
  scope :unsolved, -> { where.not(solved: true) }

  def subscribed_users
    ([user] + optin_subscribers.uniq) - optout_subscribers
  end

  def subscription_for(user)
    return nil if user.nil?

    forum_subscriptions.find_by(user_id: user.id)
  end

  def subscribed?(user)
    return false if user.nil?

    subscription = subscription_for(user)

    if subscription.present?
      subscription.subscription_type == 'optin'
    else
      forum_posts.where(user_id: user.id).any?
    end
  end

  def toggle_subscription(user)
    return unless user.auto_subscribe

    subscription = subscription_for(user)

    if subscription.present?
      subscription.toggle!
    elsif forum_posts.where(user_id: user.id).any?
      forum_subscriptions.create(user:, subscription_type: 'optout')
    else
      forum_subscriptions.create(user:, subscription_type: 'optin')
    end
  end

  def subscribed_reason(user)
    return I18n.t('.not_receiving_notifications') if user.nil?

    subscription = subscription_for(user)

    if subscription.present?
      if subscription.subscription_type == 'optout'
        I18n.t('.ignoring_thread')
      elsif subscription.subscription_type == 'optin'
        I18n.t('.receiving_notifications_because_subscribed')
      end
    elsif forum_posts.where(user_id: user.id).any?
      I18n.t('.receiving_notifications_because_posted')
    else
      I18n.t('.not_receiving_notifications')
    end
  end

  def last_post
    forum_posts.order(:created_at).last
  end

  # Notify all moderators of new thread
  def notify_users
    User.where(moderator: true)
  end
end
