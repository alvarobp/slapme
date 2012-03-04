module Slapme
  class << self
    def root
      File.expand_path(File.dirname(__FILE__) + '/..')
    end

    def background_image_path
      File.join(root, 'assets', 'batman_robin.jpg')
    end
  end
end

require 'rmagick'
require 'slapme/canvas'
require 'slapme/panel'