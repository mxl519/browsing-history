class AppsUsers < ApplicationRecord
  belongs_to :app
  belongs_to :user
end
