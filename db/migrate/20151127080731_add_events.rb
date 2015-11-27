class AddEvents < ActiveRecord::Migration
  def change
  	create_table :events do |t|

    	t.string 	:name
    	t.date		:date
    	t.time 		:time
    	t.string	:etype
    	t.string	:description
    	t.string	:gender
    	t.integer	:number
    	t.integer	:agemin
    	t.integer	:agemax
    	t.string	:location

      t.timestamps
  	end
  end
end
