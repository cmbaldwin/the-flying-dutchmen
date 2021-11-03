module Fora::ForumPostsHelper
  # Override this to use avatars from other places than Gravatar
  def avatar_tag(email)
    user = User.find_by(email: email)
    if user.avatar.attached?
      image_tag user.avatar.variant(resize: "48x48!"), class: "rounded"
    else
      inline_svg_tag('images/flying_dutchmen.svg', class: "rounded")
    end
  end

  def category_link(category)
    link_to category.name, fora.forum_category_forum_threads_path(category),
      style: "color: #{category.color}"
  end

  # Override this method to provide your own content formatting like Markdown
  def formatted_content(text)
    text
  end

  def get_page_number(forum_thread, forum_post)
    per_page = ForumPost.per_page
    (forum_thread.forum_posts.index(forum_post) / per_page) + 1
  end

  def last_post_link(forum_thread)
    last_post = forum_thread.forum_posts.last
    link_to t('.last_post'), 
        fora.forum_thread_path(forum_thread, 
          page: get_page_number(forum_thread, last_post), 
          anchor: "forum_post_#{last_post.id}"), 
        title: t('.skip_to_last_post'), 
        class: "btn btn-outline-primary mb-3 mx-1"
  end

  def forum_post_classes(forum_post)
    klasses = ["forum-post", "card", "mb-3"]
    klasses << "solved" if forum_post.solved?
    klasses << "original-poster" if forum_post.user == @forum_thread.user
    klasses
  end

  def forum_user_badge(user)
    if user.respond_to?(:moderator) && user.moderator?
      content_tag :span, "Mod", class: "badge badge-default"
    end
  end

end
