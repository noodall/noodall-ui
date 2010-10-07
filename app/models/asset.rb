class Asset
  include MongoMapper::Document
  plugin Noodall::Tagging

  # Set up dragonfly
  extend Dragonfly::ActiveModelExtensions
  register_dragonfly_app(:asset_accessor, Dragonfly::App[:noodall_assets])

  asset_accessor :file

  # Dragonfly fields
  key :file_uid, String #For dragonfly file uid
  key :file_name, String
  key :file_ext, String
  key :file_size, Integer
  key :file_mime_type, String
  key :video_thumbnail_offset, Integer, :default => 10

  key :title, String
  key :description, String
  timestamps!

  validates_presence_of :file, :title, :description
  validates_length_of :tags, :minimum => 3, :message => "must have at least 3 items"

  def image?
    !(file_mime_type =~ self.class.image_reg_ex).nil?
  end

  def video?
    file_ext == 'flv'
  end

  def url(*args)
    if args.blank?
      # Use the transparent url just the file is required with no processing
      file.url
    elsif video?
      file.encode(:tiff, { :offset => "#{video_thumbnail_offset}%" }).thumb(*args).url
    else
      file.thumb(*args).url
    end
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

    def video_extensions
      ['flv', 'avi', 'mpeg', 'mpg']
    end
  end
  extend ClassMethods

  class LogEntry
    include MongoMapper::EmbeddedDocument

    key :location, String, :required => true
    key :node_id, ObjectId, :required => true

    belongs_to :node
    embedded_in :asset
  end

  many :log_entries, :class => LogEntry
end
