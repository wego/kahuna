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

    def send_adaptive_email_campaign(body)
      # TOMHACK refactor Kahuna gem later
      body[:cred_type] = 'email'
      campaign = Api::PopulateCampaign.new(body)
      @http_client.post("#{Api::PopulateCampaign::ENDPOINT}?env=#{@env}", campaign.request_body)
    end

    def push_user_attributes(attributes)
      attributes = Api::Attribute.new(attributes)
      @http_client.post("#{Api::Attribute::ENDPOINT}?env=#{@env}", attributes.request_body)
    end

    def job_status(job_id)
      job_status = Api::JobStatus.new(job_id)
      @http_client.get(job_status.request_url(@env))
    end

    def attribute(user_attributes)
      attributes = Api::Attribute.new(user_attributes)
      @http_client.post("#{Api::Attribute::ENDPOINT}?env=#{@env}", attributes.request_body)
    end
  end
end
