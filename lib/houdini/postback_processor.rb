module Houdini
  module PostbackProcessor
    EnvironmentMismatchError = Class.new RuntimeError
    APIKeyMistmatchError     = Class.new RuntimeError

    def self.process(class_name, model_id, params)
      task_manager = params.delete(:task_manager) || TaskManager

      if params[:environment] != Houdini.environment
        raise EnvironmentMismatchError, "Environment received does not match Houdini.environment"
      end

      # # Houdini doesn't send the API key back
      # if params[:api_key] != Houdini.api_key and params[:environment] == "production"
      #   raise APIKeyMistmatchError, "API key received doesn't match our API key."
      # end

      task_manager.process class_name, model_id, params[:blueprint], params[:output], params[:verbose_output]
    end
  end
end
