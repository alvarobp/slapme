module Slapme
  module Storage
    class FileSystem
      def initialize(settings={})
        @settings = settings
      end

      def store(object_id, content)
        write_file(object_id, content)
      end

      def retrieve(object_id)
        filepath = file_path(object_id)
        raise Storage::NotFound unless File.exists?(filepath)
        File.read(filepath)
      end

      private

      def write_file(object_id, content)
        file = open_file(object_id)
        file.write(content)
        file.close
      end

      def open_file(object_id)
        raise 'Missing setting :path. Filesystem storage needs a path where to store files.' unless output_path
        File.open(file_path(object_id), 'w+')
      end

      def output_path
        @settings['path']
      end

      def file_path(object_id)
        File.join(output_path, "#{object_id}.jpg")
      end
    end
  end
end
