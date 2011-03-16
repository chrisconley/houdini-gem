class Houdini::PostbacksController < ApplicationController
  protect_from_forgery :except => [:create]
  def create
    object_class = params[:object_class].classify.constantize
    object = object_class.find(params[:object_id])
    if object.process_postback(params[:task_name], HashWithIndifferentAccess.new(ActiveSupport::JSON.decode(request.raw_post)))
      render :json => {:success => true}
    else
      render :json => {:success => false}, :status => 422
    end
  end
end