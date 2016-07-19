class AppsUsersController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def create
    AppsUsers.create!(user: current_user, app: App.find_by_name(params['app_name']))
    head 201
  end

  def index
    render status: 200, json: current_user.recent_app_history
  end

  def destroy
    AppsUsers.where(user_id: current_user.id).delete_all
    head 204
  end
end
