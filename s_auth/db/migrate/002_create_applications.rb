class CreateApplications < ActiveRecord::Migration
  def up
    create_table :applications do |t|
      t.string :name
      t.string :url
			t.integer :user_id
    end
  end

  def down
    destroy_table :applications
  end
end
