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
        # :api_key => Houdini::KEY,
        :identifier => houdini_task.name,
        :postback_url => houdini_postbacks_url(self.class.name, self.id, houdini_task.name, :host => Houdini::RAILS_HOST)
      }
      params[:price] = houdini_task.price if houdini_task.price
      params[:title] = houdini_task.title if houdini_task.title
      params[:form_html] = generate_form_html(houdini_task.form_template) if houdini_task.form_template
      params[:matched_answers_size] = houdini_task.matched_answers_size if houdini_task.matched_answers_size
      params[:max_iterations] = houdini_task.max_iterations if houdini_task.max_iterations

      [:original_text, :text, :product_name, :product_brand, :product_url].each do |attribute|
        houdini_attribute = houdini_task.send(attribute)
        if houdini_attribute #TODO: Refactor this logic and make available on all params
          params[attribute] = houdini_attribute
          params[attribute] = houdini_attribute.call if houdini_attribute.respond_to?(:call)
          params[attribute] = self.send(houdini_attribute) if self.respond_to?(houdini_attribute)
        end
      end

      result = Houdini::Base.request(houdini_task.api, params)

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

    def generate_form_html(template_path)
      template = Tilt.new(File.join(Rails.root.to_s, template_path))
      # TODO: don't force the template name
      template.render(self, self.class.name.downcase.to_sym => self)
    end
  end
end
