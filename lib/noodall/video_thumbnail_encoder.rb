require "rvideo"

class VideoThumbnailEncoder < Dragonfly::Encoding::RMagickEncoder

  def encode(image, format, encoding={})
    format = format.to_s.downcase
    throw :unable_to_handle unless supported_formats.include?(format.to_sym)
    encoded_image = rmagick_image(image, encoding[:offset])
    if encoded_image.format.downcase == format
      image # do nothing
    else
      encoded_image.format = format
      encoded_image.to_blob
    end
  end

  private

  def rmagick_image(temp_object, offset = "30%")
    vi = RVideo::Inspector.new(:file => temp_object.path)
    if vi.valid?
      voutput = RVideo::FrameCapturer.capture!( :input => temp_object.path, :offset => offset)
      Magick::Image.read(voutput).first
    else
      throw :unable_to_handle
    end
  rescue Magick::ImageMagickError => e
    log.warn("Unable to handle content in #{self.class} - got:\n#{e}")
    throw :unable_to_handle
  end
end
