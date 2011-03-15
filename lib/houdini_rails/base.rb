module Houdini
  Undefined = Class.new(NameError)
  RequestError = Class.new(NameError)
  AuthenticationError = Class.new(NameError)
  HostError = Class.new(NameError)

  class Base
    def self.request(api, params)
      puts "sending #{params.inspect} to houdini"
      validate_constants
      return ["200", '{success:"true"}'] if HOST == 'test'
      #uri = URI.parse("http://#{HOST}/api/v0/#{api}/tasks/")
      url = File.join("http://", HOST, api)
      uri = URI.parse(url)
      response, body = Net::HTTP.post_form(uri, params)

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