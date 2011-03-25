require 'spec_helper'

describe "Text Classification" do
  before do
    Article.delete_all
    Houdini::Base.stub!(:request).and_return(["200", "{response:success}"]) # TODO: VCR
  end

  it "should send task to Houdini and properly receive the postback" do
    p = Article.new(:original_text => 'This is incorect.')
    p.stub!(:id).and_return(1)

    params = {
      "api_key" => Houdini.api_key,
      "environment" => Houdini.environment,
      "postback_url" => "http://#{Houdini.app_host}/houdini/Article/1/edit_for_grammar/postbacks",
      "task_design" => "edit_for_grammar",
      "task_design_version" => 1,
      "task_info" => {
        "original_text" => "This is incorect."
      }
    }.symbolize_keys

    Houdini::Base.should_receive(:request).with(params)

    p.save
    p.reload
    p.houdini_request_sent_at.to_date.should == Time.now.to_date

    post "houdini/article/#{p.id}/edit_for_grammar/postbacks", {:edited_text => "This is incorrect."}.to_json

    p.reload
    p.edited_text.should == "This is incorrect."
  end
end