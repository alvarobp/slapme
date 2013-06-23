module Slapme
  class Canvas
    def initialize(background_path)
      @background_image = Magick::Image.read(background_path).first
      @captions = []
    end

    def add_caption(caption)
      @captions << caption
    end

    def render
      image.to_blob
    end

    private

    def image
      image_list.flatten_images
    end

    def image_list
      image_list = Magick::ImageList.new
      image_list << @background_image
      @captions.each { |c| image_list << c.render }
      image_list
    end
  end
end
