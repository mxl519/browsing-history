class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :apps

  def recent_app_history
    apps = AppsUsers.joins(:app).
      select('apps.name', "datetime(MAX(apps_users.created_at)) AS last_visited").
      group(:name).
      where(user_id: self.id).where('apps_users.created_at > ?', 1.day.ago)
    apps.inject({}) { |apps, app| apps[app.name] = app.last_visited; apps }
  end
end
