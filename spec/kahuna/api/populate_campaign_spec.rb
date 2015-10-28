require 'spec_helper'

describe Kahuna::Api::PopulateCampaign do
  describe '#request_body' do
    let(:pc) {
      Kahuna::Api::PopulateCampaign.new(
        campaign_id: '1234',
        cred_type: 'email',
        default_params: {
          today: '2015-03-13',
          breakfast: 'waffles'
        },
        recipient_list: [
          {
            k_to: [
              'yc@gmail.com'
            ],
            breakfast: 'bread'
          }
        ]
      )
    }

    it 'returns correct request body json' do
      body = {
        campaign_config: {
          target_global_control: false,
          observe_rate_limiting: false,
          campaign_id: '1234',
          cred_type: 'email'
        },
        default_params: {
          today: '2015-03-13',
          breakfast: 'waffles'
        },
        recipient_list: [
          {
            k_to: [
              'yc@gmail.com'
            ],
            breakfast: 'bread'
          }
        ]
      }.to_json
      expect(pc.request_body).to(eq(body))
    end
  end

  describe '#validate' do
    context 'campaign_id' do
      it 'raises error if missing' do
        expect {
          Kahuna::Api::PopulateCampaign.new(cred_type: 'email', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: [{ k_to: [ 'yc@gmail.com' ], breakfast: 'bread' }])
        }.to(raise_error(Kahuna::ArgumentError, 'campaign_id is missing'))
      end
    end

    context 'cred_type' do
      it 'raises error if invalid type' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'phone', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: [{ k_to: [ 'yc@gmail.com' ], breakfast: 'bread' }])
        }.to(raise_error(Kahuna::ArgumentError, 'cred_type should be one of \'username\', \'email\', \'fbid\', \'twtr\', \'lnk\', \'user_id\', \'token\''))
      end
    end

    context 'target_global_control' do
      it 'raises error if invalid' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', target_global_control: 'no', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: [{ k_to: [ 'yc@gmail.com' ], breakfast: 'bread' }])
        }.to(raise_error(Kahuna::ArgumentError, 'target_global_control should be \'true\' or \'false\''))
      end
    end

    context 'observe_rate_limiting' do
      it 'raises error if invalid' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', observe_rate_limiting: 'no', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: [{ k_to: [ 'yc@gmail.com' ], breakfast: 'bread' }])
        }.to(raise_error(Kahuna::ArgumentError, 'observe_rate_limiting should be \'true\' or \'false\''))
      end
    end

    context 'default_params' do
      it 'raises error if it is not a Hash' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', default_params: 'not a hash', recipient_list: [{ k_to: [ 'yc@gmail.com' ], breakfast: 'bread' }])
        }.to(raise_error(Kahuna::ArgumentError, 'default_params should be a Hash'))
      end

    end

    context 'recipient_list' do
      it 'raises error if it is not an Array' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: 'not an array')
        }.to(raise_error(Kahuna::ArgumentError, 'recipient_list should be an Array'))
      end

      it 'raises error if its size is smaller than 1' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: [])
        }.to(raise_error(Kahuna::ArgumentError, 'recipient_list size should be larger than 1'))
      end

      it 'raises error if recipient is not a Hash' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: ['not a hash'])
        }.to(raise_error(Kahuna::ArgumentError, 'recipient should be a Hash'))
      end

      it 'raises error if recipient k_to hash key is missing' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: [{ to: [ 'yc@gmail.com' ] }])
        }.to(raise_error(Kahuna::ArgumentError, 'recipient should have :k_to hash key'))
      end

      it 'raises error if recipient k_to hash value is not an Array' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: [{ k_to: 'yc@gmail.com', breakfast: 'bread' }])
        }.to(raise_error(Kahuna::ArgumentError, 'recipient :k_to should be an Array'))
      end

      it 'raises error if recipient k_to size is smaller than 1' do
        expect {
          Kahuna::Api::PopulateCampaign.new(campaign_id: '1234', cred_type: 'email', default_params: { today: '2015-03-13', breakfast: 'waffles' }, recipient_list: [ { k_to: [], breakfast: 'bread' } ])
        }.to(raise_error(Kahuna::ArgumentError, 'recipient :k_to size should be larger than 1'))
      end
    end
  end
end
