module Houdini
  class Task
    attr :options
    protected :options

    def initialize(klass, blueprint, options={})
      @klass              = klass
      @blueprint          = blueprint.to_s
      @input              = options[:input]
      @after_submit       = options[:after_submit]
      @on_task_completion = options[:on_task_completion] || :update_attributes
      @finder             = options[:finder] || :find
      @id_method          = options[:id_method] || :id
    end

    def process(object_id, results)
      obj = self.class.callable @klass, @finder, object_id
      self.class.callable obj, @on_task_completion, results
    end

    def submit!(object, options={})
      get_input   = options[:input_transformer] || self.class.method(:get_input)
      submit_task = options[:submit_task]       || Houdini.method(:submit!)

      id = self.class.callable object, @id_method

      submit_task.call @blueprint, object.class.name, id, get_input.call(object, @input)

      self.class.callable(object, @after_submit) if @after_submit
    end

    def self.get_input(object, input)
      input.inject({}) do |hash, (info_name, model_attribute)|
        hash.merge info_name => callable(object, model_attribute){ model_attribute }
      end
    end

    def self.callable(object, callable, *args)
      if callable.is_a? Symbol
        object.send callable, *args
      elsif callable.respond_to? :call
        object.instance_exec *args, &callable
      elsif block_given?
        yield callable, *args
      else
        raise "#{callable.inspect} is not a Symbol and does not respond to #call"
      end
    end
  end
end
