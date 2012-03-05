module Slapme
  class Caption
    include Slapme::Utils::RmagickCroppedText

    attr_accessor :text, :x, :y, :width, :height

    def initialize(text,x,y,width,height)
      @text = text
      @x = x
      @y = y
      @width = width
      @height = height
    end

    def render
      image = render_cropped_text(@text, @width, @height) do |img|
        img.gravity = Magick::CenterGravity
        img.pointsize = 10
        img.antialias = true
        img.background_color = 'transparent'
        img.font = Slapme.font_path
        img.stroke = "none"
      end
      image.tap { |img| img.page = page_rectangle(img) }
    end

    private

    def page_rectangle(image)
      Magick::Rectangle.new(image.rows, image.columns, @x, @y)
    end
  end
end
