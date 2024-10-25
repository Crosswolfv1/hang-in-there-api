class PosterSerializer
  include JSONAPI::Serializer
  set_type :posters
  attributes :name, :description, :price, :year, :vintage, :img_url

  def self.record_hash(record, fieldset, includes_list, params)
    hash = super
    hash[:id] = record.id.to_i
    hash
  end
end 