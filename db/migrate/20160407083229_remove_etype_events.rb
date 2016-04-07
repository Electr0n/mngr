class RemoveEtypeEvents < ActiveRecord::Migration
  
	def self.up
  		remove_column :events, :etype, 	:string
  	end

  	def self.down
  		add_column :events, :etype, 	:string
  	end

end
