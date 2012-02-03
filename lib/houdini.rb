require 'net/https'
require 'uri'

require 'houdini/model'
require 'houdini/task'
require 'houdini/task_manager'
require 'houdini/postback_processor'

require 'houdini/engine'

module Houdini
  mattr_accessor :environment, :api_key, :app_url, :app_uri, :app_host

  def self.setup(environment, options)
    self.environment = environment.to_s
    self.api_key = options[:api_key]
    self.app_url = options[:app_host] || options[:app_url]
    self.app_uri = URI.parse(self.app_url)
  end

  RequestError = Class.new(NameError)
  HostError = Class.new(NameError)

  HOST = 'v1.houdiniapi.com'

  def self.submit!(blueprint, class_name, object_id, input_params)
    request(
      :environment  => environment,
      :api_key      => api_key,
      :blueprint    => blueprint,
      :input        => input_params,
      :postback_url => "#{app_uri.scheme}://#{app_uri.host}:#{app_uri.port}/houdini/#{class_name}/#{object_id}/postbacks"
    )
  end

  def self.request(params)
    # TODO: this should validate sooner
    raise HostError, "Houdini.app_url should specify http:// or https://" unless app_url.match(/^https?\:\/\//)

    url = File.join("https://", HOST, "tasks.json")
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    response, body = http.post(uri.path, params.to_json)
    if response.code != "200"
      raise RequestError, "The request to houdini failed with code #{response.code}: #{body}"
    end
  end
end
