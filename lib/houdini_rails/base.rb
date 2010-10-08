module Houdini
  Undefined = Class.new(NameError)
  RequestError = Class.new(NameError)
  AuthenticationError = Class.new(NameError)

  class Base
    def self.request(api, params)
      validate_constants
      return ["200", '{success:"true"}'] if HOST == 'test'
      url = URI.parse("http://#{HOST}/api/v0/#{api}/tasks/")
      response, body = Net::HTTP.post_form(url, params)

      raise(AuthenticationError, "invalid api key") if response.code == '403'
      if response.code != "200"
        raise RequestError, "The request to houdini failed with code #{response.code}: #{body}"
      end

      [response, body]
    end

    private

    def self.validate_constants
      raise Undefined, "Houdini::KEY is not defined"  if Houdini::KEY.blank?
      raise Undefined, "Houdini::HOST is not defined" if Houdini::HOST.blank?
      raise Undefined, "Houdini::RAILS_HOST is not defined" if Houdini::RAILS_HOST.blank?
    end
  end


end