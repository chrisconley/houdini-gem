class Article < ActiveRecord::Base
  include Houdini::Model

  houdini :edit_for_grammar,
    :input => {
      'input1' => :original_text,
      'input2' => proc{ original_text },
      'input3' => "some text"
    },
    :on                 => :after_create,
    :after_submit       => :update_houdini_attributes,
    :on_task_completion => :process_houdini_edited_text,
    :finder             => lambda{|id| last },
    :id_method          => lambda{ 'model-slug' }

  def update_houdini_attributes
    update_attribute(:houdini_request_sent_at, Date.today.to_time)
  end

  def process_houdini_edited_text(output, verbose_output)
    update_attribute(:edited_text, output[:edited_text])
  end
end
