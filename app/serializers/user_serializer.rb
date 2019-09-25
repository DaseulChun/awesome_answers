class UserSerializer < ActiveModel::Serializer
  attributes(
    :id, 
    :full_name, # you can include custom methods to be serialized
    :created_at,
    :updated_at)
end
