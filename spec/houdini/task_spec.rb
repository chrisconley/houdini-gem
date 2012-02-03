require 'spec_helper'

describe Houdini::Task do
	describe "submit!(obj)" do
		class TestModel
			def id; 42; end
		end

		let(:model_object){ TestModel.new }
		let(:input){ double :input }
		it "should use the input transformer and submit it to houdini" do
			task = Houdini::Task.new TestModel, :blueprint
			submit_task = double(:callable)
			submit_task.should_receive(:call).with('blueprint', "TestModel", 42, input)
			task.submit! model_object, :input_transformer => proc{ input }, :submit_task => submit_task
		end

		it "should call the after_submit callback, when given a symbol" do
			task = Houdini::Task.new TestModel, :blueprint, :after_submit => :after_submit
			model_object.should_receive :after_submit
			task.submit! model_object, :input_transformer => proc{}, :submit_task => proc{}
		end

		it "should call the after_submit callback, when given a block" do
			task = Houdini::Task.new TestModel, :blueprint, :after_submit => proc{ after_submit }
			model_object.should_receive :after_submit
			task.submit! model_object, :input_transformer => proc{}, :submit_task => proc{}
		end

		it "should call the :id you provided to get the id" do
			task = Houdini::Task.new TestModel, :blueprint, :id_method => lambda{ 'model-id' }
			submit_task = double(:callable)
			submit_task.should_receive(:call).with('blueprint', "TestModel", 'model-id', nil)
			task.submit! model_object, :input_transformer => proc{}, :submit_task => submit_task
		end
	end

	describe ".callable" do
		let(:obj){ double :obj, :some_method => result }
		subject{ Houdini::Task.callable(obj, callable, *args) }
		let(:result){ double :result }
		let(:args){ [double(:arg1), double(:arg2)] }

		context "given a symbol" do
			let(:callable){ :some_method }
			before{ obj.should_receive(:some_method).with(*args) }
			it{ should == result }
		end

		context "given a proc" do
			let(:callable){ lambda{|*args| some_method(*args) } }
			before{ obj.should_receive(:some_method).with(*args) }
			it{ should == result }
		end

		context "given something else" do
			let(:callable){ 42 }
			it "should raise an error" do
				lambda{
					Houdini::Task.callable(obj, callable)
				}.should raise_error
			end

			context "and also given a block" do
				it "should call the block with the callable and return the result" do
					Houdini::Task.callable(double, 42){|c| c * 2 }.should == 84
				end
			end
		end
	end

	describe ".get_input" do
		subject{ Houdini::Task.get_input(input_object, input_hash) }
		let(:input_object){ double :obj, :some_method => "some input", :some_method2 => "some more input" }

		context "given an object and an instance hash" do
			let(:input_hash){  { :input1 => :some_method, :input2 => :some_method2 }  }
			it "should build a hash based on the one given, and the values in the object" do
				should == { :input1 => "some input", :input2 => "some more input" }
			end
		end
		context "given symbols" do
			let(:input_hash){ { :input1=>:some_method } }
			it "should get call the corresponding methods" do
				should == { :input1 => "some input" }
			end
		end
		context "given lambdas" do
			let(:input_hash){ { :input1=>lambda{some_method} }  }
			it "should use evaluate procs in the context of the given object" do
				should == { :input1 => "some input" }
			end
		end
		context "given procs" do
			let(:input_hash){ { :input1=>proc{some_method} }  }
			it "should use evaluate procs in the context of the given object" do
				should == { :input1 => "some input" }
			end
		end
		context "given other values" do
			let(:input_hash){ { :input1=>"some input", :input2=>42 } }
			it "should return the value, if it's not callable" do
				should == input_hash
			end
		end
	end

	describe "#process" do
		it "should call the callback on the object, giving it the houdini output, and return the result" do
			klass = double :class
			obj = double :obj
			houdini_output = double :houdini_output
			process_result = double :process_result

			task = Houdini::Task.new klass, :blueprint_name, :on_task_completion => :after_houdini_completion, :finder => :custom_finder

			klass.should_receive(:custom_finder).with(42).and_return(obj)
			obj.should_receive(:after_houdini_completion).with(houdini_output).and_return(process_result)

			task.process 42, houdini_output
		end
	end
end
