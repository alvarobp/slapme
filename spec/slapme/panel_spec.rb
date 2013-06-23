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

    describe "canvas" do
      it "builds a canvas with a background image and two captions in their corresponding position" do
        panel = Panel.new('Robin says', 'Batman slaps')
        canvas = double(:canvas)
        Slapme::Canvas.stub(:new).with(Slapme.background_image_path) { canvas }

        # Robin caption is placed at (20,4) with dimensions 130x55
        canvas.should_receive(:add_caption).ordered do |caption|
          caption.text.should == 'Robin says'
          caption.x.should == 20
          caption.y.should == 4
          caption.width.should == 130
          caption.height.should == 55
        end

        # Batman caption is placed at (182,6) with dimensions 130x52
        canvas.should_receive(:add_caption).ordered do |caption|
          caption.text.should == 'Batman slaps'
          caption.x.should == 182
          caption.y.should == 6
          caption.width.should == 130
          caption.height.should == 52
        end

        panel.canvas.should == canvas
      end

      it "sets captions with stripped text" do
        panel = Panel.new('   Robin says', '  Batman slaps   ')
        canvas = double(:canvas)
        Slapme::Canvas.stub(:new).with(Slapme.background_image_path) { canvas }
        canvas.should_receive(:add_caption) { |c| c.text.should == 'Robin says' }
        canvas.should_receive(:add_caption) { |c| c.text.should == 'Batman slaps' }
        panel.canvas
      end
    end

    describe "hash_id" do
      it "returns the SHA1 of robin text concatenated with batman text" do
        panel = Panel.new('Robin says', 'Batman slaps')
        hash_id = Digest::SHA1.hexdigest('Robin saysBatman slaps')
        panel.hash_id.should == hash_id
      end
    end

    describe "save" do
      let(:storage) { double(:storage) }
      before { Slapme.stub(:storage).and_return(storage) }

      it "stores the rendered canvas content with SHA1 hash id when valid and returns true" do
        panel = Panel.new('Robin says', 'Batman slaps')
        canvas = double(:canvas, :render => 'rendered canvas')
        canvas.stub(:add_caption)
        Slapme::Canvas.stub(:new).with(Slapme.background_image_path) { canvas }

        storage.should_receive(:store).with(panel.hash_id, 'rendered canvas')
        panel.save.should be_true
      end

      it "does not store canvas image if invalid and returns false" do
        panel = Panel.new('Robin says', '')
        storage.should_not_receive(:store)
        panel.save.should be_false
      end
    end
  end
end
