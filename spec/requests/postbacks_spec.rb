require 'spec_helper'

describe "Postbacks" do

  it "should receive postback" do
    post_record = Post.create(:image_url => 'http://google.com', :flagged => nil)
    post 'houdini/post/1/review_image/postbacks', :flagged => "yes"
    post_record.should be_flagged
  end
end