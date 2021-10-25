# This migration comes from simple_discussion (originally 20170417012932)
class CreateForumPosts < ActiveRecord::Migration[4.2]
  def change
    create_table :forum_posts do |t|
      t.references :forum_thread, foreign_key: true
      t.references :user, foreign_key: true
      # see: https://github.com/cmbaldwin/the-flying-dutchmen/commit/6b70768ed28663f8b62e9b524a1ef25c5c70b9b5#diff-a0933953a3927307e4dc4e054b9ef160d89eb16997faa1e41f01af67230c55e0R7
      t.text :body
      #accidentally commited something that should have been on fora here, swapping back to original
      t.boolean :solved, default: false

      t.timestamps
    end
  end
end
