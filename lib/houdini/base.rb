module Houdini
  RequestError = Class.new(NameError)
  HostError = Class.new(NameError)

  HOST = 'v0.houdiniapi.com'

  class Base
    def self.request(params)

      puts "sending #{params.to_json} to houdini"
      validate_config

      url = File.join("https://", HOST, "tasks.json")
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      response, body = http.post(uri.path, params.to_json)

      if response.code != "200"
        raise RequestError, "The request to houdini failed with code #{response.code}: #{body}"
      end

      [response, body]
    end

    private

    def self.validate_config
      #TODO: validate params in Houdini.setup
      raise HostError, "Houdini.app_url should specify http:// or https://" unless Houdini.app_url.match(/^https?\:\/\//)
    end
  end


end