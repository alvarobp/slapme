require 'slapme/settings'

module Slapme
  class << self
    def storage
      @storage ||= Storage.instance(storage_settings)
    end

    def root
      File.expand_path(File.dirname(__FILE__) + '/..')
    end

    def background_image_path
      File.join(root, 'assets', 'batman_robin.jpg')
    end

    def font_path
      File.join(root, 'assets', 'acmesab.ttf')
    end

    def base_uri
      Settings['base_uri']
    end

    private

    def storage_settings
      Settings['storage']
    end
  end
end

require 'RMagick'
require 'slapme/utils/rmagick_cropped_text'
require 'slapme/storage'
require 'slapme/caption'
require 'slapme/canvas'
require 'slapme/panel'
