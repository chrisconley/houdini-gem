require 'spec_helper'

describe Houdini, ".submit!" do
	it "should call .request with the right paramers" do
		Houdini.setup "some_environment", :api_key =>"SOME-API-KEY", :app_url => "http://localhost:3000"

		expected_params = {
			:environment  => "some_environment",
			:api_key      => "SOME-API-KEY",
			:blueprint    => :blueprint_name,
			:postback_url => "http://localhost:3000/houdini/ClassName/42/blueprint_name/postbacks",
			:input        => { :input1 => 1, :input2 => 'two' }
		}

		Houdini.should_receive(:request).with(expected_params)

		Houdini.submit! :blueprint_name, "ClassName", 42, :input1 => 1, :input2 => 'two'
	end
end
