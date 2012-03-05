require 'slapme'

module Slapme
  describe Caption do
    subject { Caption.new('funny thing', 123, 321, 200, 100) }

    it "has text, position and size" do
      subject.text.should == 'funny thing'
      subject.x.should == 123
      subject.y.should == 321
      subject.width.should == 200
      subject.height.should == 100
    end

    it "renders an image with cropped text" do
      image = stub
      cropped_text_image = stub.as_null_object

      subject.should_receive(:render_cropped_text).
        with('funny thing', 200, 100).
        and_yield(image).
        and_return(cropped_text_image)

      image.should_receive(:gravity=).with(Magick::CenterGravity)
      image.should_receive(:pointsize=).with(10)
      image.should_receive(:antialias=).with(true)
      image.should_receive(:background_color=).with('transparent')
      image.should_receive(:stroke=).with('none')
      image.should_receive(:font=).with(Slapme.font_path)

      subject.render.should == cropped_text_image
    end

    it "sets page to a rectangle with given position" do
      image = stub.as_null_object
      cropped_text_image = stub(:rows => stub, :columns => stub)
      subject.stub(:render_cropped_text).
        and_yield(image).
        and_return(cropped_text_image)

      page_rectangle = stub
      Magick::Rectangle.stub(:new).
        with(cropped_text_image.rows, cropped_text_image.columns, 123, 321).
        and_return(page_rectangle)
      cropped_text_image.should_receive(:page=).with(page_rectangle)

      subject.render.should == cropped_text_image
    end
  end
end
