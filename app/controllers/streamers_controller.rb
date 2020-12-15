# Streamers controller
class StreamersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_streamer, only: :show

  def index
    # Total number of events received by each streamer
    @events_by_streamer = Event.group(:streamer_name).count.to_a
    # Count of events by event_type and streamer name
    @count_of_events = Event.group(:streamer_name, :event_type).count.to_a.map(&:flatten)
  end

  def show
    @events = @live_streamer.events.order(created_at: :desc).limit(10)
  end

  def create
    streamer = Streamer.find_or_initialize_by(streamer_params)
    if streamer.stream!
      redirect_to root_path, notice: "You're now live-following your favorite streamer."
    else
      redirect_to root_path, alert: 'Something went wrong.'
    end
  end

  def update
    streamer = Streamer.find(params[:id])
    if streamer.stop!
      redirect_to root_path, notice: "You've stopped live-following your favorite streamer."
    else
      redirect_to root_path, alert: 'Something went wrong.'
    end
  end

  private

  def streamer_params
    params.require(:streamer).permit(:name)
  end

  def set_streamer
    @live_streamer = Streamer.find(params[:id])
  end
end
