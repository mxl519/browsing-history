class App < ApplicationRecord
  has_and_belongs_to_many :users

  serialize :assets, Array
end
