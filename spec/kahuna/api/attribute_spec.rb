require 'spec_helper'

describe Kahuna::Api::Attribute do
  describe '#request_body' do
    let(:a) {
      Kahuna::Api::Attribute.new([
        {
          target: {
            email: 'email@gmail.com'
          },
          attributes: {
            first_name: 'fart'
          }
        }
      ])
    }

    it 'returns correct request body json' do
      body = {
        user_attributes_array: [
          target: {
            email: 'email@gmail.com'
          },
          attributes: {
            first_name: 'fart'
          }
        ]
      }.to_json
      expect(a.request_body).to(eq(body))
    end
  end

  describe '#validate' do
    context 'user_attributes' do
      it 'raises error if missing' do
        expect {
          Kahuna::Api::Attribute.new(nil)
        }.to(raise_error(Kahuna::ArgumentError, 'user_attributes is missing'))
      end

      it 'raises error if user_attributes is not an Array' do
        expect {
          Kahuna::Api::Attribute.new({ not: 'array' })
        }.to(raise_error(Kahuna::ArgumentError, 'user_attributes should be an Array'))
      end

      it 'raises error if user_attribute is not a Hash' do
        expect {
          Kahuna::Api::Attribute.new(["not hash"])
        }.to(raise_error(Kahuna::ArgumentError, 'user_attribute should be a Hash'))
      end

      it 'raises error if user_attribute target hash key is missing' do
        expect {
          Kahuna::Api::Attribute.new([
            { attributes: { first_name: 'fart' } }
          ])
        }.to(raise_error(Kahuna::ArgumentError, 'user_attribute should have :target hash key'))
      end

      it 'raises error if user_attribute attributes hash key is missing' do
        expect {
          Kahuna::Api::Attribute.new([
            { target: { email: 'email@gmail.com' } }
          ])
        }.to(raise_error(Kahuna::ArgumentError, 'user_attribute should have :attributes hash key'))
      end
    end
  end
end
