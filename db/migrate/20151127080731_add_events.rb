class AddEvents < ActiveRecord::Migration
  def change
  	create_table :events do |t|

    	t.string 	:name
    	t.date		:date
    	t.time 		:time
      t.string	:description
    	t.string	:gender
    	t.integer	:number
    	t.integer	:agemin
    	t.integer	:agemax
    	t.string	:location

      t.timestamps
  	end

    add_index     :events, :name
    add_index     :events, :date
    add_index     :events, :gender
    add_index     :events, :number
    add_index     :events, :agemin
    add_index     :events, :agemax
    add_index     :events, :location

  end
end
