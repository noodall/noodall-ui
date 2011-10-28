class Promo < Noodall::Component
  key :title, String
  key :link, String
  key :description, String
  key :target, String

  key :asset_id, ObjectId

  belongs_to :asset
  before_save :log_asset_use

  allowed_positions :main, :small, :wide

private

  def log_asset_use
    unless asset.nil?
      asset.log_usage(_root_document.id, self.class.name)
    end
  end

end
