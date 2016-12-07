class Phone < ActiveRecord::Base

  belongs_to :user

  validates :number,  length: { minimum: 3, maximum: 9 }
  validates :code,    length: { minimum: 1, maximum: 3 }
  validates :description,  length: { maximum: 50 }
  validates :number, :code, numericality: { more_than_or_equal_to: 0 }
  
end