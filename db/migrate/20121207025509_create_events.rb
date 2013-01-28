class CreateEvents < ActiveRecord::Migration
  def up
  	create_table :events do |t|
  		t.string :address
  		t.boolean :active
  		t.integer :company_id
  		t.string :email
  		t.string :name
  		t.string :e_time
  		t.string :recurring
  		t.string :url
  		t.text :description
  		t.string :latitude
  		t.string :longitude
  		t.integer :user_id
  		t.string :phone

  		t.timestamps
  	end
  end

  def down
  	drop_table :events
  end
end
