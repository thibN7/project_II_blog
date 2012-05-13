class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :login
      t.string :password
		end
  end

  def down
    destroy_table :users
  end
end
