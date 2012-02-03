module Houdini
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      def houdini(blueprint, options={})
        task_manager = options.delete(:task_manager) || TaskManager
        callback = options.delete(:on)

        task_manager.register self, blueprint.to_sym, options

        submit_method_name = "houdini_submit_#{blueprint}!".to_sym

        # Using a module so that you can use override/modify the method via `super`
        m = Module.new do
          define_method submit_method_name do
            task_manager.submit! self, blueprint
          end
        end
        include m

        # attach the submit method via the callback
        send callback, submit_method_name if callback
      end
    end
  end
end
