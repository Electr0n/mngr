class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :vkontakte]

  has_and_belongs_to_many :events, join_table: 'events_users', class_name: 'Event'
  has_and_belongs_to_many :products, join_table: 'owners_products', class_name: 'Event'
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :tags
  accepts_nested_attributes_for :tags
  
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => 
    "120x120#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  acts_as_commontator
  
    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
        user.email = auth.uid+"@"+auth.provider+".com"
        user.password = Devise.friendly_token[0,20]
        if auth.provider != 'twitter'
          user.name = auth.extra.raw_info.first_name
          user.surname = auth.extra.raw_info.last_name
        else
          fullname      = auth.info.name.split(' ')
          user.name     = fullname[0]
          user.surname  = fullname[1]
        end
        # user.image = auth.info.image # assuming the user model has an image
      end
    end

    def country_
      Carmen::Country.coded(country).name
    end

    def city_
      Carmen::Country.coded(country).subregions.coded(city).name
    end

end
