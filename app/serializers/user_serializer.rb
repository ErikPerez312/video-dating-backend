class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :gender, :phone_number, :age, :token
  has_many :profile_images, serializer: ProfileImageSerializer

end
