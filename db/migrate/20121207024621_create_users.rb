class CreateUsers < ActiveRecord::Migration
  def up
  	create_table :users do |t|
  		t.string :username
  		t.string :password_digest
  		t.string :role
  		t.string :confirm_code
  		t.integer :customer_id

  		t.timestamps
  	end
  end

  def down
  	drop_table :users
  end
end
