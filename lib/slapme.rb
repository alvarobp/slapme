module Slapme
  class << self
    def root
      File.expand_path(File.dirname(__FILE__) + '/..')
    end

    def background_image_path
      File.join(root, 'assets', 'batman_robin.jpg')
    end

    def font_path
      File.join(root, 'assets', 'acmesab.ttf')
    end
  end
end

require 'rmagick'
require 'slapme/utils/rmagick_cropped_text'
require 'slapme/caption'
require 'slapme/canvas'
require 'slapme/panel'