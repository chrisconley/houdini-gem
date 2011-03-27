module Houdini
  module Model
    # def self.included(base)
    #   base.extend ClassMethods
    #   base.include Rails.application.routes.url_helpers
    # end

    extend ActiveSupport::Concern

    included do
      include Rails.application.routes.url_helpers
      extend ClassMethods
    end

    module ClassMethods
      def houdini(name, options)
        houdini_tasks[name.to_sym] = Houdini::Task.new(name.to_sym, options)
      end

      def houdini_tasks
        @houdini_tasks ||= {}
      end

    end

    def send_to_houdini(task_name)
      houdini_task = self.class.houdini_tasks[task_name.to_sym]
      params = {
        :environment => Houdini.environment,
        :api_key => Houdini.api_key,
        :task_design => houdini_task.short_name,
        :task_design_version => houdini_task.version,
        :postback_url => houdini_postbacks_url(self.class.name, self.id, houdini_task.short_name, {
          :protocol => Houdini.app_uri.scheme,
          :host => Houdini.app_uri.host,
          :port => Houdini.app_uri.port
        })
      }

      params[:task_info] = houdini_task.task_info.inject({}) do |hash, (info_name, model_attribute)|
        hash[info_name] = model_attribute
        hash[info_name] = model_attribute.call if model_attribute.respond_to?(:call)
        hash[info_name] = self.send(model_attribute) if self.respond_to?(model_attribute)
        hash
      end

      result = Houdini::Base.request(params)

      call_after_submit(task_name)
    end

    def process_postback(task_name, answer)
      houdini_task = self.class.houdini_tasks[task_name.to_sym]
      self.send(houdini_task.on_task_completion, answer)
    end

    def call_after_submit(task_name)
      houdini_task = self.class.houdini_tasks[task_name.to_sym]
      self.send(houdini_task.after_submit) if houdini_task.after_submit
    end
  end
end
