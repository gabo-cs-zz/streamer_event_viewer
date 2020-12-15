# Home controller
class HomeController < ApplicationController
  def index
    @live_streamer = Streamer.live.first
  end

  def streamer; end
end
