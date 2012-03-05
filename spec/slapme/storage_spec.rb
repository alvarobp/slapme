require 'slapme'

module Slapme
  describe Storage do
    let(:panel) { panel = Panel.new('Robin says', 'Batman slaps') }
    let(:hash) { Digest::SHA1.hexdigest('Robin says' + 'Batman slaps') }
    subject { Storage.new(panel) }

    it "calculates a unique identifier hash based on the panel speeches" do
      subject.hash.should == hash
    end

    it "stores files within images path named with hash and jpg extension" do
      Slapme.stub(:images_path) { "images_path" }
      subject.filepath.should == "images_path/#{hash}.jpg"
    end

    it "stores panel canvas in a jpg image with hash as name inside images path" do
      rendered_canvas = stub('rendered_canvas')
      panel.stub_chain(:canvas, :render) { rendered_canvas }
      subject.stub(:filepath) { 'panel_filepath' }

      rendered_canvas.should_receive(:write).
        with("panel_filepath")

      subject.store
    end
  end
end