class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable,
         :registerable, :rememberable, :trackable, :validatable, :omniauth_providers => [:timecrowd]

  has_many :milestones
  has_many :time_entries

  def self.find_for_oauth(auth)
    user = self.find_by(uid: auth.uid, provider: auth.provider)
    unless user
      user = self.create(
        uid: auth.uid,
        provider: auth.provider,
        email: self.dummy_email(auth),
        password: Devise.friendly_token[0, 20],
        token: auth.credentials.token
      )
    else
      user.token = auth.credentials.token
      user.save
    end

    user
  end

  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@timeout.dev"
  end
end
