require 'slapme'

module Slapme
  describe Canvas do
    let(:background_image) { stub('background_image').as_null_object }

    before do
      Magick::Image.stub(:read).
        with('background_path') { background_image }
    end

    subject { Canvas.new('background_path') }

    it "keeps a list of captions" do
      caption1 = stub
      caption2 = stub
      subject.captions << caption1
      subject.captions << caption2
      subject.captions.should == [caption1, caption2]
    end

    it "renders a flatten image list with background image followed by all its rendered captions" do
      caption1 = stub(:render => 'rendered1')
      caption2 = stub(:render => 'rendered2')
      subject.captions << caption1
      subject.captions << caption2

      image_list = stub('image_list')
      Magick::ImageList.should_receive(:new) { image_list }

      image_list.should_receive(:<<).ordered.with(background_image)
      image_list.should_receive(:<<).ordered.with('rendered1')
      image_list.should_receive(:<<).ordered.with('rendered2')

      image_list.should_receive(:flatten_images).ordered { 'rendered image' }
      subject.render.should == 'rendered image'
    end
  end
end