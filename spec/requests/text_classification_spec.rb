require 'spec_helper'

describe "Text Classification" do
  before do
    ProductReview.delete_all
  end

  it "should send task to Houdini and properly receive the postback" do
    p = ProductReview.create(:original_text => 'This is a spam revew', :category => nil)

    p.reload
    p.houdini_request_sent_at.to_date.should == Time.now.to_date

    post "houdini/product_review/#{p.id}/text_classification/postbacks", {:category => "spam"}.to_json

    p.reload
    p.category.should == "spam"
  end
end