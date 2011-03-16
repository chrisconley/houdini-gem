class ProductReview < ActiveRecord::Base
  include Houdini::Model

  houdini :text_classification,
    :text => :original_text,
    :api => "classification",
    :after_submit => :update_houdini_attributes,
    :on_task_completion => :process_image_moderation_answer

  after_create :moderate_image, :if => :original_text

  def moderate_image
    Houdini.perform!(:text_classification, self)
  end

  def update_houdini_attributes
    update_attribute(:houdini_request_sent_at, Time.now)
  end

  def process_image_moderation_answer(params)
    update_attribute(:category, params[:category])
  end
end
