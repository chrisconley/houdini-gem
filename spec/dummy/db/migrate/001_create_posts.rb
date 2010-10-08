class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.text :image_url
      t.boolean :flagged
      t.datetime :houdini_request_sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
