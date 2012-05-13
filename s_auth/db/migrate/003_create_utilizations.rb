class CreateUtilizations < ActiveRecord::Migration
  def up
    create_table :utilizations do |t|
      t.integer :user_id
      t.integer :application_id
    end
  end

  def down
    destroy_table :utilizations
  end
end
