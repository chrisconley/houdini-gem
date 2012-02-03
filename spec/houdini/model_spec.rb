require 'spec_helper'

describe Houdini::Model do
	let :test_model do
		Class.new do
			include Houdini::Model
		end
	end

	describe ".houdini" do
		it "should define a method that submits the task" do
			task_manager = double :task_manager
			task_manager.should_receive(:register).with(test_model, :blueprint_name, :other_options => {})
			test_model.houdini :blueprint_name, :task_manager => task_manager, :other_options => {}

			test_model_instance = test_model.new

			task_manager.should_receive(:submit!).with(test_model_instance, :blueprint_name)
			test_model_instance.houdini_submit_blueprint_name!
		end

		it "should attach callback methods" do
			test_model.should_receive(:after_create).with(:houdini_submit_blueprint_name!)
			test_model.houdini :blueprint_name, :on => :after_create
		end
	end
end
