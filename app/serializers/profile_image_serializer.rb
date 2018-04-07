class ProfileImageSerializer < ActiveModel::Serializer
  attributes :id, :url

  def url
    object.image_file.url()
  end
end
