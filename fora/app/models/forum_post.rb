class ForumPost < ApplicationRecord
  belongs_to :forum_thread, counter_cache: true, touch: true
  belongs_to :user

  has_rich_text :text
  
  validates :user_id, :text, presence: true

  scope :sorted, -> { order(:created_at) }

  after_update :solve_forum_thread, if: :solved?
  
  def solve_forum_thread
    forum_thread.update(solved: true)
  end
end
