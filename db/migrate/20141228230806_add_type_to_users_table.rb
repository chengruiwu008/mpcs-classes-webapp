class AddTypeToUsersTable < ActiveRecord::Migration
  def change
    add_column :users, :type, :string, default: "Student", null: false
  end
end
