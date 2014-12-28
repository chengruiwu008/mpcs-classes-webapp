class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :cnet
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :affiliation
      t.string :department

      t.timestamps
    end
  end
end
