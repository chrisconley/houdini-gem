require 'cgi'
class Houdini::PostbacksController < ApplicationController
  skip_before_filter :protect_from_forgery

  def create
    task_results = HashWithIndifferentAccess.new ActiveSupport::JSON.decode(request.raw_post)

    Houdini::PostbackProcessor.process CGI.unescape(params[:object_class]), params[:object_id], task_results
    render :json => { :success => true }
  end
end
