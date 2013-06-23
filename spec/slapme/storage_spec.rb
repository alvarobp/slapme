require 'slapme'

module Slapme
  describe Storage do
    it "instances Storage::FileSystem when file_system storage settings are present" do
      file_system_settings = double(:file_system_settings)
      storage_settings = { 'file_system' => file_system_settings }
      storage_instance = double(:storage_instance)
      Slapme::Storage::FileSystem.stub(:new).
        with(file_system_settings).
        and_return(storage_instance)
      Slapme::Storage.instance(storage_settings).should == storage_instance
    end

    it "instances Storage::S3 when s3 storage settings are present" do
      s3_settings = double(:s3_settings)
      storage_settings = { 's3' => s3_settings }
      storage_instance = double(:storage_instance)
      Slapme::Storage::S3.stub(:new).
        with(s3_settings).
        and_return(storage_instance)
      Slapme::Storage.instance(storage_settings).should == storage_instance
    end
  end
end
