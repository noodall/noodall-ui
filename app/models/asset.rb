class Asset
  include MongoMapper::Document
  plugin Noodall::Tagging
  plugin Noodall::GlobalUpdateTime

  # Set up dragonfly
  extend Dragonfly::ActiveModelExtensions
  register_dragonfly_app(:asset_accessor, Dragonfly::App[:noodall_assets])

  asset_accessor :file do

    Noodall::UI::Assets.system_image_sizes.each do |name, size|
      copy_to(name.to_sym) { |file| file.thumb(size) }
    end

    Noodall::UI::Assets.image_sizes.each do |name, size|
      copy_to(name.to_sym) { |file| file.thumb(size) }
    end
  end

  # Dragonfly fields
  key :file_uid, String #For dragonfly file uid
  key :file_name, String
  key :file_ext, String
  key :file_size, Integer
  key :file_mime_type, String
  key :video_thumbnail_offset, Integer, :default => 10

  # Setup additional image sizes if we're using Amazon S3 or local storage
  if [:amazon_s3, :filesystem].include? Noodall::UI::Assets.storage

    # System thumbnails used by Noodall
    Noodall::UI::Assets.system_image_sizes.each do |name, size|
      asset_accessor name
      key "#{name}_uid".to_sym, String
    end

    # Images used configured by the user
    Noodall::UI::Assets.image_sizes.each do |name, size|
      asset_accessor name
      key "#{name}_uid".to_sym, String
    end
  end

  key :title, String
  key :description, String
  timestamps!

  validates_presence_of :file, :title, :description
  validates_length_of :tags, :minimum => 1, :message => "must have at least 1 item"

  # Set up video format
  cattr_accessor :video_extensions
  self.video_extensions = []

  def image?
    !(file_mime_type =~ self.class.image_reg_ex).nil?
  end

  def video?
    @@video_extensions.include?(file_ext)
  end

  def url(*args)
    if args.blank?
      # Use the transparent url just the file is required with no processing
      file.url
    elsif video?
      file.encode(:tiff, { :offset => "#{video_thumbnail_offset}%" }).thumb(*args).url
    else
      file.thumb(*args).strip.convert('-colorspace RGB').url
    end
  end

  def web_image_extension
    # If the extension id anything other than a png or gif then it should be a jpg
    case file_ext
    when 'png', 'gif'
      file_ext
    else
      'jpg'
    end.to_sym
  end

  def dragonfly_extension_sym
    warn "[DEPRECATION] `dragonfly_extension_sym` is deprecated.  Please use `web_image_extension` instead."
    web_image_extension
  end

  def file_uid
    # Required to rerun the correct object for Dragonfly pending
    return Dragonfly::ActiveRecordExtensions::PendingUID.new if @file_uid == "PENDING"
    @file_uid
  end

  def log_usage(node_id, location)
    # Check it's not been logged here before
    if log_entries.select{|l| l.node_id.to_s == node_id.to_s and l.location == location  }.empty?
      log_entry = LogEntry.new(:node_id => node_id, :location => location)
      if log_entry.valid?
        self.log_entries << log_entry
        self.save(:validate => false)
      end
    end
  end

  protected

  def set_title
    self.title = file_name.gsub(/\.[\w\d]{3,4}$/,'').titleize if title.blank?
  end
  before_save :set_title

  module ClassMethods
    def images
      Asset.all(:conditions => {:file_ext.in => self.image_extensions})
    end

    def files
      Asset.all(:conditions => {:file_ext.nin => self.image_extensions + self.video_extensions})
    end

    def image_reg_ex
      /^image\/(#{self.image_extensions.join('|')})$/
    end

    def image_extensions
      ['png','gif','jpg','jpeg']
    end
  end
  extend ClassMethods

  class LogEntry
    include MongoMapper::EmbeddedDocument

    key :location, String, :required => true
    key :node_id, ObjectId, :required => true

    belongs_to :node, :class => Noodall::Node
    embedded_in :asset
  end

  many :log_entries, :class => LogEntry
end
