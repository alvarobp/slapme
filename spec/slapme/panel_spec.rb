require 'slapme'

module Slapme
  describe Panel do
    it "has a Robin speech and a Batman speech" do
      panel = Panel.new('Robin says', 'Batman slaps')
      panel.robin.should == 'Robin says'
      panel.batman.should == 'Batman slaps'
    end

    it "needs Robin to say something" do
      panel = Panel.new('', 'Batman slaps')

      panel.should_not be_valid
      panel.errors.should include('Robin must have something to say')
    end

    it "needs Batman to have a reason for slapping Robin" do
      panel = Panel.new('Robin says', '')

      panel.should_not be_valid
      panel.errors.should include('Batman never slaps Robin without a reason')
    end

    it "builds a canvas with background image and two captions" do
      panel = Panel.new('Robin says', 'Batman slaps')
      canvas = stub('canvas', :captions => [])
      Slapme::Canvas.stub(:new).with(Slapme.background_image_path) { canvas }

      panel.canvas

      # Robin caption is placed at (20,4) with dimensions 130x55
      robin_caption = canvas.captions.detect { |c| c.text == 'Robin says' }
      robin_caption.should_not be_nil
      robin_caption.x.should == 20
      robin_caption.y.should == 4
      robin_caption.width.should == 130
      robin_caption.height.should == 55

      # Batman caption is placed at (182,6) with dimensions 130x52
      batman_caption = canvas.captions.detect { |c| c.text == 'Batman slaps' }
      batman_caption.should_not be_nil
      batman_caption.x.should == 182
      batman_caption.y.should == 6
      batman_caption.width.should == 130
      batman_caption.height.should == 52
    end

    it "stores the canvas image when valid" do
      panel = Panel.new('Robin says', 'Batman slaps')
      panel.stub(:valid? => true)
      Storage.should_receive(:new).with(panel) {
        stub(:filename => 'hash.jpg').
          tap {|s| s.should_receive(:store) }
      }
      panel.save.should == 'hash.jpg'
    end

    it "does not store canvas image if invalid" do
      panel = Panel.new('Robin says', '')
      panel.stub(:valid? => false)
      Storage.should_not_receive(:new).with(panel)
      panel.save.should be_nil
    end
  end
end
