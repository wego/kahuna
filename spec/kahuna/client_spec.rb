require 'spec_helper'

describe Kahuna::Client do
  subject(:client) {
    Kahuna::Client.new(
      secret_key: 'test_secret',
      api_key: 'test_api',
      env: 'staging'
    )
  }

  context 'when initializing a new Kahuna::Client' do
    it 'raise error if api_key missing' do
      expect {
        Kahuna::Client.new(secret_key: 'test_secret')
      }.to(raise_error(Kahuna::ConfigurationError))
    end

    it 'raise error if secret_key missing' do
      expect {
        Kahuna::Client.new(api_key: 'test_api')
      }.to(raise_error(Kahuna::ConfigurationError))
    end

    it 'assigns production environment if environment is production' do
      kc = Kahuna::Client.new(
        secret_key: 'test_secret',
        api_key: 'test_api',
        env: 'production'
      )
      expect(kc.env).to(eq('p'))
    end

    it 'assigns staging environment if environment is staging' do
      kc = Kahuna::Client.new(
        secret_key: 'test_secret',
        api_key: 'test_api',
        env: 'staging'
      )
      expect(kc.env).to(eq('s'))
    end

    it 'fallbacks to staging environment for all other environments' do
      kc = Kahuna::Client.new(
        secret_key: 'test_secret',
        api_key: 'test_api',
        env: 'stage'
      )
      expect(kc.env).to(eq('s'))
    end
  end

  describe '#populate_campaign' do
    it 'response status code of 200' do
      stub_request(:post, "https://test_secret:test_api@tap-nexus.appspot.com/api/campaign/populate?env=s").
        with(:body => "{\"campaign_config\":{\"target_global_control\":false,\"observe_rate_limiting\":false,\"campaign_id\":1234,\"cred_type\":\"email\"},\"default_params\":{},\"recipient_list\":[{\"k_to\":[\"yc@gmail.com\"],\"breakfast\":\"bread\"}]}",
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(:status => 200, :body => "", :headers => {})
      body = {
        campaign_id: 1234,
        cred_type: 'email',
        recipient_list: [
          {
            k_to: [
              'yc@gmail.com'
            ],
            breakfast: 'bread'
          }
        ]
      }
      expect(client.populate_campaign(body).status).to(eq(200))
    end
  end

  describe '#job_status' do
    it 'response status code of 200' do
      stub_request(:get, "https://test_secret:test_api@tap-nexus.appspot.com/api/campaign/populate/jobid?env=s").
        with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(:status => 200, :body => "", :headers => {})
      expect(client.job_status('jobid').status).to(eq(200))
    end
  end

  describe '#attribute' do
    it 'response status code of 200' do
      stub_request(:post, "https://test_secret:test_api@tap-nexus.appspot.com/api/userattributes?env=s").
        with(:body => "{\"user_attributes_array\":[{\"target\":{\"email\":\"email@gmail.com\"},\"attributes\":{\"first_name\":\"fart\"}}]}",
             :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
        to_return(:status => 200, :body => "", :headers => {})
      body = [
        {
          target: {
            email: 'email@gmail.com'
          },
          attributes: {
            first_name: 'fart'
          }
        }
      ]
      expect(client.attribute(body).status).to(eq(200))
    end
  end

  describe '#update_user_attributes_by_email' do
    it 'response status code of 200' do
      stub_request(:post, "https://test_secret:test_api@tap-nexus.appspot.com/api/userattributes?env=s").
          with(:body => "{\"user_attributes_array\":[{\"target\":{\"email\":\"email@gmail.com\"},\"attributes\":{\"first_name\":\"fart\"}}]}",
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 200, :body => "", :headers => {})

      expect(client.update_user_attributes_by_email('email@gmail.com', first_name: 'fart').status).to(eq(200))
    end
  end

  describe '#send_adaptive_email_campaign' do
    it 'response status code of 200' do
      stub_request(:post, "https://test_secret:test_api@tap-nexus.appspot.com/api/campaign/populate?env=s").
          with(:body => "{\"campaign_config\":{\"target_global_control\":false,\"observe_rate_limiting\":false,\"campaign_id\":1234,\"cred_type\":\"email\"},\"default_params\":{},\"recipient_list\":[{\"k_to\":[\"yc@gmail.com\"],\"breakfast\":\"bread\"}]}",
               :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Faraday v0.9.2'}).
          to_return(:status => 200, :body => "", :headers => {})

      recipient_list = [
        {
          k_to: [
            'yc@gmail.com'
          ],
          breakfast: 'bread'
        }
      ]

      expect(client.send_adaptive_email_campaign(1234, recipient_list).status).to(eq(200))
    end
  end
end
