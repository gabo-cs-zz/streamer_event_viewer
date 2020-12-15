# Event model
class Event < ApplicationRecord
  enum event_type: %i[follow subscribe]

  belongs_to :streamer, primary_key: 'name', foreign_key: 'streamer_name'

  after_commit :broadcast_new_event, on: :create

  def self.create_upon_webhook(subscription_params, event_params)
    create do |event|
      event.streamer_name = event_params[:broadcaster_user_name].downcase
      event.event_type = subscription_params[:type].split('.').last
      event.viewer_name = event_params[:user_name]
    end
  end

  private

  # Broadcast new event to the streamer page
  def broadcast_new_event
    Pusher.trigger("#{streamer_name}-channel", 'new-event', {
      event_id: id,
      event_type: event_type,
      viewer_name: viewer_name
    })
  end
end
