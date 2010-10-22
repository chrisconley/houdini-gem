module Houdini
  module Model
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def houdini(name, options)
        include Rails.application.routes.url_helpers
        cattr_accessor :houdini_task
        self.houdini_task = Houdini::Task.new(name, options)
      end
    end

    def send_to_houdini(task_name)
      # TODO: look up task when multiple tasks per model are implemented
      result = Houdini::Base.request(houdini_task.api,
        :api_key => Houdini::KEY,
        :identifier => houdini_task.name,
        :price => houdini_task.price,
        :title => houdini_task.title,
        :form_html => generate_form_html(houdini_task.form_template),
        :postback_url => houdini_postbacks_url(self.class.name, self.id, self.houdini_task.name, :host => Houdini::RAILS_HOST))

      call_after_submit
    end

    def process_postback(answer)
      self.send(houdini_task.on_task_completion, answer)
    end

    def call_after_submit
      self.send(houdini_task.after_submit) if houdini_task.after_submit
    end

    def generate_form_html(template_path)
      template = Tilt.new(File.join(Rails.root.to_s, template_path))
      # TODO: don't force the template name
      template.render(self, self.class.name.downcase.to_sym => self)
    end
  end
end