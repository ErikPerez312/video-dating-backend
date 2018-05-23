class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :gender, :phone_number, :age, :token, :seeking
  has_many :profile_images, serializer: ProfileImageSerializer

end
