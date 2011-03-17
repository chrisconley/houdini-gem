require 'net/https'
require 'uri'

require 'tilt'

require 'houdini_rails/base'
require 'houdini_rails/model'
require 'houdini_rails/task'

require 'houdini_rails/engine'


module Houdini
  # Convenience method
  def self.perform!(task_name, object)
    object.send_to_houdini(task_name)
  end
end