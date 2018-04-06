class ProfileImageSerializer < ActiveModel::Serializer
  attributes :id, :url

  def url
    object.voice_file.url()
  end
end
