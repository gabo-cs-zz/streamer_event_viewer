# Streamer model
class Streamer < ApplicationRecord
  include AASM

  has_many :events, primary_key: 'name', foreign_key: 'streamer_name', dependent: :destroy

  validates :name, presence: true, uniqueness: true

  aasm(:status) do
    state :off, initial: true
    state :live

    event :stream, after: :initiate_event_listeners do
      transitions from: :off, to: :live, guard: :can_go_live?
    end

    event :stop, after: :kill_event_listeners do
      transitions from: :live, to: :off
    end
  end

  def can_go_live?
    Streamer.live.count.zero?
  end

  def initiate_event_listeners
    twitch.subscribe_to_follows_events
    twitch.subscribe_to_subscriptions_events
  end

  def kill_event_listeners
    twitch.delete_subscriptions
  end

  private

  def twitch
    @twitch ||= TwitchService.new(name)
  end
end
