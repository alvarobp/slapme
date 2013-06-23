require 'slapme'

module Slapme
  describe Settings do
    let(:settings_path) { Slapme.root + '/config/settings.yml' }

    before do
      @original_settings = Slapme::Settings.instance_variable_get(:@settings)
      Slapme::Settings.instance_variable_set(:@settings, nil)
    end

    after do
      Slapme::Settings.instance_variable_set(:@settings, @original_settings)
    end

    it "loads ERB rendered settings from /config/settings.yml" do
      File.stub(:exists?).with(settings_path) { true }

      read_file = double(:read_file)
      File.stub(:read).with(settings_path).and_return(read_file)
      erb_rendered_file = double(:erb_rendered_file)
      erb = double(:result => erb_rendered_file)
      ERB.stub(:new).with(read_file).and_return(erb)

      YAML.stub(:load).with(erb_rendered_file) {
        { 'images_path' => '/path/to/images' }
      }
      Slapme::Settings['images_path'].should == '/path/to/images'
    end

    it "raises an error if settings file does not exist" do
      File.stub(:exists?).with(settings_path) { false }
      expect {
        Slapme::Settings['images_path']
      }.to raise_error('Configuration file missing. Copy config/examples/settings.yml to config/settings.yml with you configurations')
    end
  end
end
