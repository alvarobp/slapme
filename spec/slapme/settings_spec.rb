require 'slapme'

module Slapme
  describe Settings do
    before do
      @original_settings = Slapme::Settings.instance_variable_get(:@settings)
      Slapme::Settings.instance_variable_set(:@settings, nil)
    end

    after do
      Slapme::Settings.instance_variable_set(:@settings, @original_settings)
    end

    it "loads settings from /config/settings.yml" do
      File.stub(:exists?).with(Slapme.root + '/config/settings.yml') { true }
      YAML.stub(:load_file).with(Slapme.root + '/config/settings.yml') {
        { 'images_path' => '/path/to/images' }
      }
      Slapme::Settings['images_path'].should == '/path/to/images'
    end

    it "raises an error if settings file does not exist" do
      File.stub(:exists?).with(Slapme.root + '/config/settings.yml') { false }
      expect {
        Slapme::Settings['images_path']
      }.to raise_error('Configuration file missing. Copy config/examples/settings.yml to config/settings.yml with you configurations')
    end
  end
end