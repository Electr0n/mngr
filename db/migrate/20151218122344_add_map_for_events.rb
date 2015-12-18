class AddMapForEvents < ActiveRecord::Migration
  
	def self.up
		add_column :events, :latitude, 	:float
		add_column :events, :longitude, :float
		add_column :events, :gmaps,		:boolean

	    add_index     :events, :latitude
	    add_index     :events, :longitude
	end

	def self.down
		remove_column	:events, :latitude, 	:float
		remove_column	:events, :longitude, 	:float
		remove_column	:events, :gmaps, 		:boolean
	end

end
