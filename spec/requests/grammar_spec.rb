require 'spec_helper'

describe "Text Classification" do
  before do
    Article.delete_all
  end

  it "should send task to Houdini and properly receive the postback" do
    p = Article.create(:original_text => 'This is incorect.')

    p.reload
    p.houdini_request_sent_at.to_date.should == Time.now.to_date

    post "houdini/article/#{p.id}/edit_for_grammar/postbacks", :edited_text => "This is incorrect."

    p.reload
    p.edited_text.should == "This is incorrect."
  end
end