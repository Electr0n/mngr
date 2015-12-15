class Event < ActiveRecord::Base
	
  has_and_belongs_to_many :users

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  acts_as_commontable

  validates :name, length: {maximum: 100, minimum: 5}
  validates :agemin, :agemax, :number, numericality: { greater_than_or_equal_to: 0 }

end