class MatchSerializer < ActiveModel::Serializer
  attributes :id, :cantor_identifier, :is_match, :updated_at
  has_many(:users, serializer: UserSerializer)

  def userss
    object.users
  end
end
