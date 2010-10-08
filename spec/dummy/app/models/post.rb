class Post < ActiveRecord::Base
  include Houdini::Model

  houdini :image_moderation,
    :title => 'Moderate Image',
    :form_template => 'app/views/posts/houdini_template.html.erb',
    :after_submit => :update_houdini_attributes,
    :on_task_completion => :process_image_moderation_answer,
    :price => '0.01'

  after_create :moderate_image, :if => :image_url

  def moderate_image
    Houdini.perform!(:image_moderation, self)
  end

  def update_houdini_attributes
    update_attribute(:houdini_request_sent_at, Time.now)
  end

  def process_image_moderation_answer(params)
    update_attribute(:flagged, params[:flagged] == 'yes')
  end
end
