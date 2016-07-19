class App < ApplicationRecord
  has_and_belongs_to_many :users

  serialize :assets, Array

  def self.listing
    @listing ||= App.all.inject([]) { |apps, app| apps << { 'name' => app.name, 'urls' => app.assets }; apps }
  end
end
