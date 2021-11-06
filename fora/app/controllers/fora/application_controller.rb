class Fora::ApplicationController < ::ApplicationController
  before_action :check_user

  def check_user
    return if user_signed_in? #can also use current_user.method? to check various things
    flash[:notice] = 'Unauthorized. Only registered and confirmed users can view the forum at this time.'
    redirect_to root_path, error: 'Unauthorized'
  end

  layout "fora"

  def page_number
    page = params.fetch(:page, "").gsub(/[^0-9]/, "").to_i
    page = "1" if page.zero?
    page
  end

  def get_page_number(forum_thread, forum_post)
    per_page = ForumPost.per_page
    (forum_thread.forum_posts.index(forum_post) / per_page) + 1
  end

  def is_moderator_or_owner?(object)
    # if thread owner is a moderator, revert to owner only
    if object.user.respond_to?(:moderator)
      object.user == current_user
    else
      is_moderator? || object.user == current_user
    end
  end
  helper_method :is_moderator_or_owner?

  def is_moderator?
    current_user.respond_to?(:moderator) && current_user.moderator?
  end
  helper_method :is_moderator?

  def require_mod_or_author_for_post!
    unless is_moderator_or_owner?(@forum_post)
      redirect_to_root
    end
  end

  def require_mod_or_author_for_thread!
    unless is_moderator_or_owner?(@forum_thread)
      redirect_to_root
    end
  end

  private

  def redirect_to_root
    redirect_to fora.root_path, alert: "You aren't allowed to do that."
  end
end
