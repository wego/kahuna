$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'kahuna'
require 'webmock/rspec'

RSpec.configure do |config|
  config.include WebMock::API
end
