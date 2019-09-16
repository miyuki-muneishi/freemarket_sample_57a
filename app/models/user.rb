class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,:omniauthable,
         omniauth_providers: [:facebook, :google_oauth2]


  has_many :sns_credential
  has_one :shipping_address
  accepts_nested_attributes_for :shipping_address
  accepts_nested_attributes_for :sns_credential





  def self.find_omniauth(auth)

    uid = auth.uid
    provider = auth.provider
    snscredential = SnsCredential.where(uid: uid, provider: provider).first
    
    if snscredential.present?
      user = User.where(id: snscredential.user_id).first
    else
      user = User.where(email: auth.info.email).first
      if user.present?
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id)
      else
        user = User.new(
          name: auth.info.name,
          email:    auth.info.email,
          password: Devise.friendly_token[0, 20],
          phone_number: "00000000000"
          )
        SnsCredential.create(
          uid: uid,
          provider: provider,
          user_id: user.id)
          # binding.pry
      end
    end
    return user
  end
end


# def self.find_omniauth(auth)
#   where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
#     # binding.pry
#     user.email = auth.info.email
#     user.password = Devise.friendly_token[0, 20]

#     end
#   end