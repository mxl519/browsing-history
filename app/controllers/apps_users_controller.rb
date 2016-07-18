class AppsUsersController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!

  def create
    AppsUsers.create!(user: current_user, app: App.find_by_name(params['app_name']))
    render status: 201, nothing: true
  end

  def index
    apps = AppsUsers.joins(:app).select('apps.name', 'MAX(apps_users.created_at) AS last_visited').group(:name)
    .where(user_id: current_user.id).where('apps_users.created_at > ?', 1.day.ago)
    render status: 200, json: apps.inject({}) { |apps, app| apps[app.name] = app.last_visited; apps } 
  end

  def destroy
    AppsUsers.where(user_id: current_user.id).delete_all
    render status: 204, nothing: true
  end
end
