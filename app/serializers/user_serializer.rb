class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :phone_number, :token, :age, :bio
  has_many :profile_images, serializer: ProfileImageSerializer

end
