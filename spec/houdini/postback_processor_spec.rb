require 'spec_helper'

describe Houdini::PostbackProcessor, ".process!" do
  let(:houdini_settings) do
    { :environment => "production", :api_key => "MY_KEY", :app_url => "http://localhost:3000" }
  end
  context "when the environments dont match" do
    before do
      Houdini.setup "production", houdini_settings
    end

    it "should raise an EnvironmentMismatchError" do
      lambda{
        Houdini::PostbackProcessor.process 'Class', 42, :environment => "sandbox"
      }.should raise_error(Houdini::PostbackProcessor::EnvironmentMismatchError)
    end
  end

  context "when in production and given API key doesn't match" do
    it "should raise an APIKeyMistmatchError" do
			pending "Houdini doesn't send the API key back."
      lambda{
        Houdini::PostbackProcessor.process 'Class', 42, :environment => "production", :api_key => "ANOTHER_KEY"
      }.should raise_error(Houdini::PostbackProcessor::APIKeyMistmatchError)
    end
  end

  context "given a classname and id" do
    it "should load the object, and have it process the postback, and return the result" do
      task_manager   = double :task_manager
      output         = double :output
      verbose_output = double :verbose_output

      task_manager.should_receive(:process).with('MyClass', 42, 'blueprint_name', output, verbose_output)

      Houdini::PostbackProcessor.process 'MyClass', 42, houdini_settings.merge(
        :blueprint      => 'blueprint_name',
        :output         => output,
        :verbose_output => verbose_output,
        :task_manager   => task_manager
      )
    end
  end
end
