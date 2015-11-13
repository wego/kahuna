module Kahuna
  class HttpClient
    attr_accessor :connection

    def initialize(base_url, username, password)
      raise ConfigurationError if base_url.nil? || username.nil? || password.nil?

      @connection = Faraday.new(url: base_url)
      @connection.basic_auth(username, password)
      @connection
    end

    def post(endpoint, request_body)
      @connection.post do |req|
        req.url endpoint
        req.headers['Content-Type'] = 'application/json'
        req.body = request_body
      end
    end

    def get(endpoint)
      @connection.get endpoint
    end
  end
end
