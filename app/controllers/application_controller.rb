class ApplicationController < ActionController::Base
  before_action :unauthorized_resource_redirect

  private

  def unauthorized_resource_redirect
    redirect_to root_path if devise_controller? && resource_name == :user && action_name == 'new'
  end
end
