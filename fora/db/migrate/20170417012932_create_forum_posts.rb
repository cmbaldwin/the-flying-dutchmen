class CreateForumPosts < ActiveRecord::Migration[4.2]
  def change
    create_table :forum_posts do |t|
      t.references :forum_thread, foreign_key: true
      t.references :user, foreign_key: true
      t.text :rich_text
      t.boolean :solved, default: false

      t.timestamps
    end
  end
end
