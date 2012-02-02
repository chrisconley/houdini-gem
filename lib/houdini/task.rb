module Houdini
  class Task
    attr_accessor :short_name, :input, :after_submit, :on_task_completion

    def initialize(short_name, options)
      @short_name         = short_name.to_s
      @input              = options[:input]
      @after_submit       = options[:after_submit]
      @on_task_completion = options[:on_task_completion] || :update_attributes
    end
  end
end
