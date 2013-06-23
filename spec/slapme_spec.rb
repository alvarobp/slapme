require 'slapme'

describe Slapme do
  describe ".storage" do
    it "instances using Storage.instance with storage settings" do
      storage_settings = double(:storage_settings)
      Slapme::Settings.stub(:[]).with('storage') { storage_settings }
      storage_instance = double(:storage_instance)
      Slapme::Storage.stub(:instance).with(storage_settings).and_return(storage_instance)
      Slapme.storage.should == storage_instance
    end
  end
end
