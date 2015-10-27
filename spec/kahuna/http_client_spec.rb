require 'spec_helper'

describe Kahuna::HttpClient do
  context 'when initializing a new Kahuna::HttpClient' do
    it 'raise error if base_url missing' do
      expect {
        Kahuna::HttpClient.new(nil, 'username', 'password')
      }.to(raise_error(Kahuna::ConfigurationError))
    end

    it 'raise error if username missing' do
      expect {
        Kahuna::HttpClient.new('base_url', nil, 'password')
      }.to(raise_error(Kahuna::ConfigurationError))
    end

    it 'raise error if password missing' do
      expect {
        Kahuna::HttpClient.new('base_url', 'username', nil)
      }.to(raise_error(Kahuna::ConfigurationError))
    end

    it 'assigns to connections and return' do
      client = Kahuna::HttpClient.new('base_url', 'username', 'password')
      expect(client).not_to be_nil
    end
  end

  describe '#post' do
    it 'returns status code of 200 if username and password are correct' do
      stub_request(:post, "http://username:password@testkahuna.com/api/campaign/populate").
        with(body: "{\"key\":\"value\"}",
              headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
                'Content-Type' => 'application/json', 
                'User-Agent' => 'Faraday v0.9.0'
              }
        ).
        to_return(status: 200)
      client = Kahuna::HttpClient.new('http://testkahuna.com', 'username', 'password')
      expect(client.post('/api/campaign/populate', { 'key' => 'value' }.to_json).status).to(eq(200))
    end

    it 'returns status code of 401 if username and password are wrong' do
      stub_request(:post, "http://wusernamew:wpasswordw@testkahuna.com/api/campaign/populate").
        with(body: "{\"key\":\"value\"}",
              headers: {
                'Accept' => '*/*',
                'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 
                'Content-Type' => 'application/json', 
                'User-Agent' => 'Faraday v0.9.0'
              }
        ).
        to_return(status: 401)
      client = Kahuna::HttpClient.new('http://testkahuna.com', 'wusernamew', 'wpasswordw')
      expect(client.post('/api/campaign/populate', { 'key' => 'value' }.to_json).status).to(eq(401))
    end
  end
end
