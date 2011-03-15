class Article < ActiveRecord::Base
  include Houdini::Model

  houdini :edit_for_grammar,
    :original_text => :original_text,
    :api => "grammar",
    :after_submit => :update_houdini_attributes,
    :on_task_completion => :process_houdini_edited_text

  after_create :moderate_image, :if => :original_text

  def moderate_image
    Houdini.perform!(:edit_for_grammar, self)
  end

  def update_houdini_attributes
    update_attribute(:houdini_request_sent_at, Time.now)
  end

  def process_houdini_edited_text(params)
    update_attribute(:edited_text, params[:edited_text])
  end
end
