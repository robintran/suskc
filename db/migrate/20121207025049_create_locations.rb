class CreateLocations < ActiveRecord::Migration
  def up
  	create_table :locations do |t|
  		t.string :name
  		t.text :description
  		t.string :address
  		t.string :phone
  		t.string :email
  		t.string :url
  		t.string :twitter
  		t.string :facebook
  		t.string :latitude
  		t.string :longitude
  		t.boolean :active
  		t.boolean :paid	
  		t.string :logo
  		t.integer :user_id
  		t.string :category
  		t.string :sub_category

  		t.timestamps
  	end
  end

  def down
  	drop_table :locations
  end
end
