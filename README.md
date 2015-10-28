# Kahuna


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kahuna', github: 'yeouchien/kahuna'
```

And then execute:

    $ bundle

## Usage

#### Populate Campaign API
```ruby
client = Kahuna::Client.new(
  secret_key: 'secret',
  api_key: 'test_api',
  env: 'staging || production'
)

response = client.populate_campaign({
  campaign_id: '1234',
  cred_type: 'email',
  target_global_control: false,
  observe_rate_limiting: false,
  default_params: {
    today: '2015-03-13',
    breakfast: 'waffles'
  },
  recipient_list: [
    {
      k_to: [
        'yeouchien@gmail.com'
      ],
      breakfast: 'bread'
    }
  ]
})
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/yeouchien/kahuna. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

