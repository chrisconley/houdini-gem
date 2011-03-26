module Houdini
  Undefined = Class.new(NameError)
  RequestError = Class.new(NameError)
  AuthenticationError = Class.new(NameError)
  HostError = Class.new(NameError)

  HOST = 'houdini2-staging.heroku.com'

  class Base
    def self.request(params)

      puts "sending #{params.to_json} to houdini"
      validate_config

      url = File.join("https://", HOST, "tasks.json")
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response, body = http.post(uri.path, params.to_json)

      if response.code != "200"
        raise RequestError, "The request to houdini failed with code #{response.code}: #{body}"
      end

      [response, body]
    end

    private

    def self.validate_config
      raise HostError, "Houdini.app_host should specify http:// or https://" unless Houdini.app_host.match(/^https?\:\/\//)
    end
  end


end