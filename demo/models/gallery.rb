class Gallery < Noodall::Component
  many :promos
  
  allowed_positions :small, :wide, :main
  
  before_save :filter_contents
  
  def filter_contents
    self.promos.reject!{|c| c.asset_id.blank? && c.title.blank? && c.body.blank?} unless self.contents.blank?
  end


end
