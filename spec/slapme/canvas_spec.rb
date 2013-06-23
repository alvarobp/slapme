require 'slapme'

module Slapme
  describe Canvas do
    let(:background_image) { double(:background_image).as_null_object }

    before do
      Magick::Image.stub(:read).
        with('background_path') { background_image }
    end

    subject { Canvas.new('background_path') }

    it "keeps a list of captions" do
      caption = double(:caption)
      subject.add_caption caption
    end

    describe "render" do
      let(:image_list) { double(:image_list).as_null_object }
      before { Magick::ImageList.stub(:new).and_return(image_list) }

      it "builds and flattens Magick::ImageList layering the background image with rendered captions on top" do
        caption1 = double(:caption1, :render => 'rendered1')
        caption2 = double(:caption2, :render => 'rendered2')
        subject.add_caption caption1
        subject.add_caption caption2

        image_list.should_receive(:<<).ordered.with(background_image)
        image_list.should_receive(:<<).ordered.with('rendered1')
        image_list.should_receive(:<<).ordered.with('rendered2')
        image_list.should_receive(:flatten_images).ordered

        subject.render
      end

      it "returns built image list as blob" do
        flattened_images = double(:flattened_images, :to_blob => 'RENDERED BLOB')
        image_list.stub(:flatten_images).and_return(flattened_images)
        subject.render.should == 'RENDERED BLOB'
      end
    end
  end
end
