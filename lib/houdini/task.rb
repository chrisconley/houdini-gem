module Houdini
  class Task
    attr_accessor :short_name, :version, :task_info, :on, :if, :after_submit, :on_task_completion

    def initialize(short_name, options)
      @short_name = short_name.to_s
      @version = options[:version]
      @task_info = options[:task_info]
      @on = options[:on] || :after_create
      @if = options[:if] || true
      @after_submit = options[:after_submit]
      @on_task_completion = options[:on_task_completion] || :update_attributes
    end
  end
end
