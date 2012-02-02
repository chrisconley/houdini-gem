class Houdini::PostbacksController < ApplicationController
  skip_before_filter :protect_from_forgery

  def create
    post_params = HashWithIndifferentAccess.new ActiveSupport::JSON.decode(request.raw_post)

    if post_params[:environment] != Houdini.environment
      raise "Environment received does not match Houdini.environment"
    end

    if post_params[:environment] == "production" and post_params[:api_key] == Houdini.api_key
      raise "API key received doesn't match our API key."
    end

    object_class = params[:object_class].classify.constantize
    object = object_class.find params[:object_id]

    if object.process_postback post_params[:blueprint], post_params[:output]
      render :json => { :success => true }
    else
      render :json => { :success => false }, :status => 422
    end
  end
end
