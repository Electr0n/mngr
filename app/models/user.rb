class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :twitter, :vkontakte]

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  	def self.from_omniauth(auth)
  		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    	user.email = auth.uid+"@"+auth.provider+".com"
	    	user.password = Devise.friendly_token[0,20]
		    if auth.provider != 'twitter'
		    	user.name = auth.info.first_name
		    	user.surname = auth.info.last_name
		    else
		    	user.name = 'N/A'
		    	user.surname = 'N/A'
		    end
		    #user.image = auth.info.image # assuming the user model has an image
  		end
	end

end
