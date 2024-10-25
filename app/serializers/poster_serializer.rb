class PosterSerializer
  include JSONAPI::Serializer
  set_type :posters
  attributes :name, :description, :price, :year, :vintage, :img_url
end
