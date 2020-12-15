# frozen_string_literal: true

# Twitch Service
class TwitchService
  CLIENT_ID = Rails.application.credentials.dig(:twitch, :client_id)
  CLIENT_SECRET = Rails.application.credentials.dig(:twitch, :client_secret)
  HOST = Rails.application.routes.default_url_options[:host]

  private

  attr_reader :streamer_name

  def initialize(streamer_name)
    @streamer_name = streamer_name
  end

  public

  def subscribe_to_follows_events
    client.post('/helix/eventsub/subscriptions', follows_events_body.to_json)
  end

  def subscribe_to_subscriptions_events
    client.post('/helix/eventsub/subscriptions', subscriptions_events_body.to_json)
  end

  def delete_subscriptions
    response = client.get('/helix/eventsub/subscriptions')
    JSON.parse(response.body)['data'].each do |item|
      client.delete("/helix/eventsub/subscriptions?id=#{item['id']}")
    end
  end

  private

  def follows_events_body
    event_request_body 'follow'
  end

  def subscriptions_events_body
    event_request_body 'subscribe'
  end

  def event_request_body(type)
    {
      'type' => "channel.#{type}",
      'version' => '1',
      'condition' => {
        'broadcaster_user_id' => user_id.to_s
      },
      'transport' => {
        'method' => 'webhook',
        'callback' => "#{HOST}/events",
        'secret' => 'mefirniano'
      }
    }
  end

  def user_id
    response = client.get("/helix/users?login=#{streamer_name}")
    parsed_response = JSON.parse(response.body, object_class: OpenStruct)
    parsed_response.data.first.id
  end

  def client
    @client ||= Faraday.new('https://api.twitch.tv') do |client|
      client.request :url_encoded
      client.adapter Faraday.default_adapter
      client.headers['Authorization'] = "Bearer #{app_token}"
      client.headers['Content-Type'] = 'application/json'
      client.headers['Client-Id'] = CLIENT_ID
    end
  end

  def app_token
    response = Faraday.post(
      'https://id.twitch.tv/oauth2/token'\
      "?client_id=#{CLIENT_ID}"\
      "&client_secret=#{CLIENT_SECRET}"\
      '&grant_type=client_credentials'\
      '&scope=channel:read:subscriptions'
    )
    JSON.parse(response.body)['access_token']
  end
end
