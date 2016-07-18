class AppController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def index
    render json: App.first(2).inject([]) { |apps, app| apps << { 'name' => app.name, 'urls' => app.assets }; apps }
  end
end
