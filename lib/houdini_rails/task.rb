module Houdini
  class Task
    attr_accessor :name, :api, :on, :if, :price, :title, :form_template, :after_submit, :on_task_completion

    def initialize(name, options)
      @name = name
      @api = "simple" # options[:strategy]
      @on = options[:on] || :after_create
      @if = options[:if] || true
      @price = options[:price]
      @title = options[:title]
      @form_template = options[:form_template]
      @after_submit = options[:after_submit]
      @on_task_completion = options[:on_task_completion] || :update_attributes
    end
  end
end