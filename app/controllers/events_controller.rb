# Events controller
class EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    Event.create_upon_webhook(subscription_params, event_params) unless params[:event].empty?
    render plain: params['challenge'], status: :ok
  end

  private

  def subscription_params
    params.require(:subscription).permit(:type)
  end

  def event_params
    params.require(:event).permit(:user_name, :broadcaster_user_id, :broadcaster_user_name)
  end
end
