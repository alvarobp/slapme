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
      y = @y
      if image.rows < @height
        y += ((@height - image.rows).to_f / 2.0).to_i
      end
      Magick::Rectangle.new(image.rows, image.columns, @x, y)
    end
  end
end
