require 'slapme'

describe Slapme do
  describe "#images_path" do
    it "is set to <root>/tmp/images if setting is missing" do
      Slapme::Settings.stub(:[]).with('images_path') { nil }
      Slapme.images_path.should == Slapme.root + '/tmp/images'
    end

    it "is set to <root>/tmp/images if setting is empty" do
      Slapme::Settings.stub(:[]).with('images_path') { '' }
      Slapme.images_path.should == Slapme.root + '/tmp/images'
    end

    it "is set to Settings['images_path'] if present" do
      Slapme::Settings.stub(:[]).with('images_path') { '/a/path/to/images' }
      Slapme.images_path.should == '/a/path/to/images'
    end
  end
end