class Content < Noodall::Component
  key :title, String
  key :url, String
  key :url_text, String
  key :body, String
  key :target, String

  key :asset_id, ObjectId

  belongs_to :asset
  before_save :log_asset_use

  alias description body
private

  def log_asset_use
    unless asset.nil?
      location = self.instance_of?(Content) ? self._parent_document.class.name : self.class.name
      asset.log_usage(_root_document.id, location)
    end
  end

end
