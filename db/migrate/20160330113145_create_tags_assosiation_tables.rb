class CreateTagsAssosiationTables < ActiveRecord::Migration
  def change
    create_table :tags_users, id: false do |t|

  		t.belongs_to	:user, 	index: true
  		t.belongs_to	:tag, 	index: true
  	
  	end
  	create_table :events_tags, id: false do |t|

  		t.belongs_to	:event, 	index: true
  		t.belongs_to	:tag, 		index: true
  	
  	end
  end
end
