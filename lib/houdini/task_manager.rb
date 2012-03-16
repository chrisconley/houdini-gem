module Houdini
  module TaskManager
    def self.register(klass, blueprint, options, task_builder=Task)
      @tasks ||= {}
      @tasks[ [klass.name, blueprint.to_sym] ] = task_builder.new(klass, blueprint, options)
    end

    def self.submit!(object, blueprint)
      if @tasks
        task = @tasks[ [object.class.name, blueprint.to_sym] ]
        task.submit! object
      end
    end

    def self.process(class_name, id, blueprint, output, verbose_output)
      task = @tasks[ [class_name, blueprint.to_sym] ]
      task.process id, output, verbose_output
    end
  end
end
