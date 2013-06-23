require 'slapme'

module Slapme::Storage
  describe FileSystem do
    let(:output_path) { '/my/output/path' }
    let(:options) { { 'path' => output_path } }
    subject { FileSystem.new(options) }

    describe "store" do
      it "stores file within configured path" do
        file_path = File.join(output_path, 'theid.jpg')
        file = double(:file)
        File.stub(:open).
          with(file_path, 'w+').
          and_return(file)
        file.should_receive(:write).with('CONTENT')
        file.should_receive(:close)
        subject.store('theid', 'CONTENT')
      end

      it "raises an exception if path setting is not given" do
        storage = FileSystem.new
        expect {
          storage.store('theid', 'CONTENT')
        }.to raise_error { |err| err.message.include?('Missing setting path') }
      end
    end

    describe "retrieve" do
      it "reads file from configured path if file exists" do
        file_path = File.join(output_path, 'theid.jpg')
        file = double(:file)
        File.stub(:exists?).with(file_path).and_return(true)
        File.stub(:read).with(file_path).and_return('CONTENT')
        subject.retrieve('theid')
      end

      it "raises Storage::NotFound if file does not exist" do
        file_path = File.join(output_path, 'theid.jpg')
        File.stub(:exists?).with(file_path).and_return(false)
        expect {
          subject.retrieve('theid')
        }.to raise_error(Slapme::Storage::NotFound)
      end
    end
  end
end
