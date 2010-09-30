class FileList < Content
  many :contents
  
  allowed_positions :small, :wide
  
  before_save :filter_contents
  
  def filter_contents
    self.contents.reject!{|c| c.asset_id.blank? && c.title.blank? && c.body.blank?} unless self.contents.blank?
  end


end
