# This is a major fix for migrating from simple_discussion to fora
# Needs to be run in conjunction with something like
# `ForumPost.all.each {|post| p post.body if (post.text.body.nil? && !post.body.nil?)};nil` in console
class AddTextToForumPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :forum_posts, :text, :rich_text
  end
end
