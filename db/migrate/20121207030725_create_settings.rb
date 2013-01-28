class CreateSettings < ActiveRecord::Migration
  def up
  	create_table :settings do |t|
  		t.string :name
  		t.string :value
  		t.string :svalue

  		t.timestamps
  	end
  end

  def down
  	drop_table :settings
  end
end
