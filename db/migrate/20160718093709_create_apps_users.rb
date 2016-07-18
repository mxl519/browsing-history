class CreateAppsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :apps_users, id: false do |t|
      t.references :app, index: true
      t.references :user, index: true

      t.timestamps
    end

    add_index :apps_users, :created_at
  end
end
