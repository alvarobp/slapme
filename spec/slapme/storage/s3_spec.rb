require 'slapme'

module Slapme::Storage
  describe S3 do
    let(:options) do
      {
        'access_key_id' => 'ACCESSKEYID',
        'secret_access_key' => 'SECRETACCESSKEY',
        'bucket' => 'my-bucket',
        'path' => 'some_path'
      }
    end
    subject { S3.new(options) }

    describe "store" do
      it "stores file in s3 bucket inside configured path" do
        s3_file_should_be_stored('some_path/theid.jpg', 'CONTENT')
        subject.store('theid', 'CONTENT')
      end

      it "stores file in s3 bucket root if no path is configured" do
        s3_file_should_be_stored('theid.jpg', 'CONTENT')
        nopath_options = options.reject { |k,v| k == 'path' }
        S3.new(nopath_options).store('theid', 'CONTENT')
      end

      def s3_file_should_be_stored(path, content)
        s3_object_double(path).should_receive(:write).with(content)
      end
    end

    describe "retrieve" do
      it "reads file from s3 bucket in path if file exists" do
        s3_file_is_read('some_path/theid.jpg', 'CONTENT')
        subject.retrieve('theid').should == 'CONTENT'
      end

      it "reads file from s3 bucket from root if path is not configured and file exists" do
        s3_file_is_read('theid.jpg', 'CONTENT')
        nopath_options = options.reject { |k,v| k == 'path' }
        S3.new(nopath_options).retrieve('theid').should == 'CONTENT'
      end

      it "raises Storage::NotFound if file does not exist" do
        s3_object_double('some_path/theid.jpg').stub(:exists?) { false }
        expect {
          subject.retrieve('theid')
        }.to raise_error(Slapme::Storage::NotFound)
      end

      def s3_file_is_read(path, content)
        s3_object = s3_object_double(path)
        s3_object.stub(:exists?) { true }
        s3_object.stub(:read).and_return(content)
      end
    end

    def s3_object_double(path)
      aws_s3 = double(:aws_s3)
      s3_bucket = double(:s3_bucket)
      s3_object = double(:s3_object)
      AWS::S3.stub(:new).with(:access_key_id => 'ACCESSKEYID', :secret_access_key => 'SECRETACCESSKEY').and_return(aws_s3)
      aws_s3.stub(:buckets).and_return('my-bucket' => s3_bucket)
      s3_bucket.stub(:objects).and_return(path => s3_object)
      s3_object
    end
  end
end
