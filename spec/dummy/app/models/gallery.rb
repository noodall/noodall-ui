class Gallery < Noodall::Component
  many :promos
  key :title, String, :default => "Gallery"
  key :description, String
  key :asset_ids, Array, :typecast => 'ObjectId'
  
  
  def assets
    assets = Asset.all(:id => asset_ids)
    asset_ids.map do |id|
      assets.find{|a| a._id == id}
    end.compact
  end
  
  allowed_positions :small, :wide, :main
  
end
