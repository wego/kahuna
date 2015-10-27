module Kahuna
  module Api
    class PopulateCampaign
      ENDPOINT = '/api/campaign/populate'.freeze
      CRED_TYPES = ['username', 'email', 'fbid', 'twtr', 'lnk', 'user_id', 'token'].freeze

      def initialize(data)
        @campaign_id = data[:campaign_id]
        @cred_type = data[:cred_type]
        @target_global_control = data[:target_global_control] || false
        @observe_rate_limiting = data[:observe_rate_limiting] || false
        @default_params = data[:default_params] || {}
        @recipient_list = data[:recipient_list]
        validate
      end

      def request_body
        {
          'campaign_config' => {
            'target_global_control' => @target_global_control,
            'observe_rate_limiting' => @observe_rate_limiting,
            'campaign_id' => @campaign_id,
            'cred_type' => @cred_type
          },
          'default_params' => @default_params,
          'recipient_list' => @recipient_list
        }.to_json
      end

      def validate
        raise(ArgumentError, 'campaign_id is missing') if @campaign_id.nil?
        raise(ArgumentError, 'cred_type should be one of \'username\', \'email\', \'fbid\', \'twtr\', \'lnk\', \'user_id\', \'token\'') unless CRED_TYPES.include?(@cred_type)
        raise(ArgumentError, 'target_global_control should be \'true\' or \'false\'') unless [true, false].include?(@target_global_control)
        raise(ArgumentError, 'observe_rate_limiting should be \'true\' or \'false\'') unless [true, false].include?(@observe_rate_limiting)
        raise(ArgumentError, 'default_params should be a Hash') unless @default_params.is_a?(Hash)
        raise(ArgumentError, 'recipient_list should be an Array') unless @recipient_list.is_a?(Array)
        raise(ArgumentError, 'recipient_list size should be larger than 1') if @recipient_list.size < 1
        @recipient_list.each do |r|
          raise(ArgumentError, 'recipient should be a Hash') unless r.is_a?(Hash)
          raise(ArgumentError, 'recipient should have \'k_to\' hash key') unless r.has_key?('k_to')
          raise(ArgumentError, 'recipient \'k_to\' should be an Array') unless r['k_to'].is_a?(Array)
          raise(ArgumentError, 'recipient \'k_to\' size should be larger than 1') if r['k_to'].size < 1
        end
      end
    end
  end
end
