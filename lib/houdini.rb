require 'net/https'
require 'uri'

require 'houdini/base'
require 'houdini/model'
require 'houdini/task'

require 'houdini/engine'


module Houdini
  mattr_accessor :environment, :api_key, :app_url, :app_uri, :app_host
  # Convenience methods
  def self.perform!(task_name, object)
    object.send_to_houdini(task_name)
  end

  def self.setup(environment, options)
    self.environment = environment.to_s
    self.api_key = options[:api_key]
    self.app_url = options[:app_host] || options[:app_url]
    self.app_uri = URI.parse(self.app_url)
  end
end