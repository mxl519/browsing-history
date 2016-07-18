# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

YAML.load_file('db/seeds/apps.yml').each do |name, assets|
  next if App.find_by_name(name)

  app = App.create!(name: name, assets: assets)
end
