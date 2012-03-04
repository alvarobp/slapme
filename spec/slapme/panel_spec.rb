require 'slapme/panel'

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
  end
end
