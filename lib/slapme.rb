require 'slapme/settings'

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

    def images_path
      File.join(root, 'tmp', 'images')
    end
  end
end

require 'rmagick'
require 'slapme/utils/rmagick_cropped_text'
require 'slapme/caption'
require 'slapme/canvas'
require 'slapme/storage'
require 'slapme/panel'