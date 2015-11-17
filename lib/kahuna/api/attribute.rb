module Kahuna
  module Api
    class Attribute
      ENDPOINT = '/api/userattributes'.freeze

      def initialize(user_attributes)
        @user_attributes = user_attributes

        validate
      end

      def request_body
        {
          'user_attributes_array' => @user_attributes
        }.to_json
      end

      def validate
        raise(ArgumentError, 'user_attributes is missing') if @user_attributes.nil?
        raise(ArgumentError, 'user_attributes should be an Array') unless @user_attributes.is_a?(Array)
        @user_attributes.each do |ua|
          raise(ArgumentError, 'user_attribute should be a Hash') unless ua.is_a?(Hash)
          raise(ArgumentError, 'user_attribute should have :target hash key') unless ua.has_key?(:target)
          raise(ArgumentError, 'user_attribute should have :attributes hash key') unless ua.has_key?(:attributes)
        end
      end
    end
  end
end
