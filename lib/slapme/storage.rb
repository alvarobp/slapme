module Slapme
  module Storage
    class NotFound < StandardError; end

    require 'slapme/storage/file_system'
    require 'slapme/storage/s3'

    class << self
      def instance(settings)
        storage_class(settings).new(storage_settings(settings))
      end

      def storage_class(settings)
        key = settings.keys.first
        class_name = key.sub(/^[a-z\d]*/) { $&.capitalize }
        class_name.gsub!(/_([a-z\d]+)/) { $1.capitalize }
        Slapme::Storage.const_get(class_name)
      end

      def storage_key(settings)
        settings.keys.first
      end

      def storage_settings(settings)
        settings.values.first
      end
    end
  end
end
