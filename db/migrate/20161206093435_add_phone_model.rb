class AddPhoneModel < ActiveRecord::Migration
  
  def change
    create_table :phones do |t|
      t.integer   :user_id
      t.integer	  :code
      t.integer		:number
      t.string    :description
    end
  end

end
