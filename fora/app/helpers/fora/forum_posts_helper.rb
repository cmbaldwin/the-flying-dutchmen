module Fora::ForumPostsHelper
  # Override this to use avatars from other places than Gravatar
  def avatar_tag(email)
    user = User.find_by(email:)
    return unless user.avatar.attached?

    image_tag user.avatar.variant(resize: '48x48!'), class: 'rounded img-fluid'
  end

  def category_link(category)
    link_to category.name, fora.forum_category_forum_threads_path(category),
            style: "color: #{category.color}"
  end

  # Override this method to provide your own content formatting like Markdown
  def formatted_content(text)
    if current_user.new_window
      formatted_text = Nokogiri::HTML(text.body.to_rendered_html_with_layout)
      formatted_text.css('a').each do |link|
        link['target'] = '_blank'
      end
      formatted_text.to_html.html_safe
    else
      text
    end
  end

  def get_page_number(forum_thread, forum_post)
    per_page = ForumPost.per_page
    (forum_thread.forum_posts.order(:created_at).index(forum_post) / per_page) + 1
  end

  def last_post_link(forum_thread)
    last_post = forum_thread.last_post
    link_to t('.last_post'),
            fora.forum_thread_path(forum_thread,
                                   page: get_page_number(forum_thread, last_post),
                                   anchor: "forum_post_#{last_post.id}"),
            title: t('.skip_to_last_post'),
            class: 'btn btn-sm btn-outline-primary mb-3 mx-1 d-flex align-items-center justify-content-center align-middle'
  end

  def forum_post_classes(forum_post)
    klasses = %w[forum-post card mb-3]
    klasses << 'solved' if forum_post.solved?
    klasses << 'original-poster' if forum_post.user == @forum_thread.user
    klasses
  end

  def forum_user_badge(user)
    return unless user.respond_to?(:moderator) && user.moderator?

    content_tag :span, 'Mod', class: 'badge badge-default'
  end
end
