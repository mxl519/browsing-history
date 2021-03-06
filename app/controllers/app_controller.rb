class AppController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    render json: App.listing
  end
end
