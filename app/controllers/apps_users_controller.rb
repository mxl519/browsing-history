class AppsUsersController < ActionController::Base
  protect_from_forgery with: :exception

  def create
    if current_user
      AppsUsers.create!(user: current_user, app: App.find_by_name(params['app_name']))
      render status: 201, nothing: true
    else
      render status: 403, nothing: true
    end
  end

  def index
    if current_user
      apps = AppsUsers.joins(:app).select('apps.name', 'MAX(apps_users.created_at) AS last_visited').group(:name).where(user_id: current_user.id)
      render status: 200, json: apps.inject({}) { |apps, app| apps[app.name] = app.last_visited; apps } 
    else
      render status: 403, nothing: true
    end
  end
end
