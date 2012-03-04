module Slapme
  class Canvas
    attr_accessor :captions

    def initialize(background_path)
      @background_image = Magick::Image.read(background_path).first
      @captions = []
    end

    def render
      Magick::ImageList.new.tap do |image_list|
        image_list << @background_image
        @captions.each { |c| image_list << c.render }
      end.flatten_images
    end
  end
end