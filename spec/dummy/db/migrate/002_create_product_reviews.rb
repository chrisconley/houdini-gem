class CreateProductReviews < ActiveRecord::Migration
  def self.up
    create_table :product_reviews do |t|
      t.text :original_text
      t.string :category
      t.datetime :houdini_request_sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :product_reviews
  end
end
