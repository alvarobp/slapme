require 'aws/s3'

module Slapme
  module Storage
    class S3
      def initialize(settings={})
        @settings = settings
      end

      def store(object_id, content)
        s3_object(object_id).write(content)
      end

      def retrieve(object_id)
        object = s3_object(object_id)
        raise Storage::NotFound unless object.exists?
        object.read
      end

      private

      def remote_path(object_id)
        segments = ["#{object_id}.jpg"]
        segments.unshift(@settings['path']) if @settings['path']
        File.join(segments)
      end

      def aws_s3
        AWS::S3.new(:access_key_id => @settings['access_key_id'], :secret_access_key => @settings['secret_access_key'])
      end

      def s3_bucket
        aws_s3.buckets[@settings['bucket']]
      end

      def s3_object(object_id)
        bucket = s3_bucket
        object_name = remote_path(object_id)
        s3_object = bucket.objects[object_name]
      end
    end
  end
end
