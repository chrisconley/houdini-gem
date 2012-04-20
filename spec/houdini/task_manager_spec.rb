require 'spec_helper'

describe Houdini::TaskManager do
  describe ".register, .submit!, and .process" do
    class MyClass; end

    it "should save it and let us call it again, when we give the right blueprint and class" do
      options                = double :options
      task_builder           = double :task_builder
      task                   = double :task
      obj                    = MyClass.new
      houdini_output         = double :houdini_output
      verbose_houdini_output = double :verbose_houdini_output
      processing_result      = double :processing_result

      task_builder.should_receive(:new).with(MyClass, :blueprint_name, options).and_return(task)
      Houdini::TaskManager.register(MyClass, :blueprint_name, options, task_builder)

      task.should_receive(:submit!).with(obj)
      Houdini::TaskManager.submit!(obj, :blueprint_name)

      task.should_receive(:process).with(42, houdini_output, verbose_houdini_output).and_return(processing_result)
      Houdini::TaskManager.process('MyClass', 42, 'blueprint_name', houdini_output, verbose_houdini_output).should == processing_result
    end
  end
end
