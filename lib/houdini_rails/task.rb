module Houdini
  class Task
    attr_accessor :name, :api, :on, :if, :price, :title, :form_template, :text, :original_text, :after_submit, :on_task_completion, :matched_answers_size, :max_iterations, :product_name, :product_brand, :product_url

    def initialize(name, options)
      @name = name
      @api = options[:api] || "simple"
      @on = options[:on] || :after_create
      @if = options[:if] || true
      @price = options[:price]
      @title = options[:title]
      @form_template = options[:form_template]
      [:original_text, :text, :product_name, :product_brand, :product_url].each do |attribute|
        self.send("#{attribute}=", options[attribute])
      end
      @after_submit = options[:after_submit]
      @on_task_completion = options[:on_task_completion] || :update_attributes
      @matched_answers_size = options[:matched_answers_size]
      @max_iterations = options[:max_iterations]
    end
  end
end
