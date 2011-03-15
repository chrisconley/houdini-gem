class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.text :original_text
      t.text :edited_text
      t.datetime :houdini_request_sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
