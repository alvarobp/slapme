require 'slapme'

describe Slapme do
  describe ".storage" do
    it "instances Storage::FileSystem with file_system storage settings" do
      storage = double(:storage)
      file_system_settings = double(:file_system_settings)
      storage_settings = { 'file_system' => file_system_settings }
      Slapme::Settings.stub(:[]).with('storage') { storage_settings }
      Slapme::Storage::FileSystem.stub(:new).
        with(file_system_settings).
        and_return(storage)
      Slapme.storage.should == storage
    end
  end
end
