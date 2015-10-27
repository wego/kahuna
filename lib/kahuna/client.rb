module Kahuna
  class Client
    attr_accessor :api_key, :secret_key, :env

    BASE_URL = 'https://tap-nexus.appspot.com'.freeze

    def initialize(config)
      raise ConfigurationError if config[:api_key].nil? || config[:secret_key].nil?

      @api_key = config[:api_key]
      @secret_key = config[:secret_key]
      @env = (config[:env] == 'production') ? 'p' : 's'
      @http_client = HttpClient.new(BASE_URL, @secret_key, @api_key)
    end

    def populate_campaign(body)
      campaign = Api::PopulateCampaign.new(body)
      @http_client.post("#{Api::PopulateCampaign::ENDPOINT}?env=#{@env}", campaign.request_body)
    end
  end
end
