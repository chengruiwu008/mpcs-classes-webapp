class AddPublishedToQuarters < ActiveRecord::Migration
  def change
    add_column :quarters, :published, :boolean, default: false, null: false
  end
end
