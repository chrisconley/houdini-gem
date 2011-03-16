module Houdini
  Undefined = Class.new(NameError)
  RequestError = Class.new(NameError)
  AuthenticationError = Class.new(NameError)
  HostError = Class.new(NameError)

  class Base
    def self.request(api, params)
      puts "sending #{params.to_json} to houdini"
      validate_constants
      #uri = URI.parse("http://#{HOST}/api/v0/#{api}/tasks/")
      url = File.join("http://", HOST, "tasks", api)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      response, body = http.post(uri.path, params.to_json)

      raise(AuthenticationError, "invalid api key") if response.code == '403'
      if response.code != "200"
        raise RequestError, "The request to houdini failed with code #{response.code}: #{body}"
      end

      [response, body]
    end

    private

    def self.validate_constants
      # raise Undefined, "Houdini::KEY is not defined"  if Houdini::KEY.blank?
      raise Undefined, "Houdini::HOST is not defined" if Houdini::HOST.blank?
      raise HostError, "Houdini::HOST should not include http://" if Houdini::HOST.match(/http/)
      raise Undefined, "Houdini::RAILS_HOST is not defined" if Houdini::RAILS_HOST.blank?
      raise HostError, "Houdini::RAILS_HOST should not include http://" if Houdini::RAILS_HOST.match(/http/)
    end
  end


end