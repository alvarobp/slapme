require 'slapme'
require 'slapme/server'
require 'rack/test'

module Slapme
  describe Server do
    include Rack::Test::Methods

    let(:storage) { double(:storage) }
    before do
      Slapme.stub(:base_uri).and_return('http://slapme.test')
      Slapme.stub(:storage).and_return(storage)
    end

    describe '/slaps.json' do
      it "responds with slap url if panel is valid" do
        robin_says = 'Hey Batman, do you think...'
        batman_says = 'Shut up for once'
        panel = double(:panel, :save => true, :hash_id => 'HASH')
        Slapme::Panel.stub(:new).with(robin_says, batman_says) { panel }

        post '/slaps.json', :robin => robin_says, :batman => batman_says

        last_response.should be_ok
        MultiJson.decode(last_response.body).should == {
          'url' => 'http://slapme.test/slaps/HASH.jpg'
        }
      end

      it "responds with unprocessable entity and errors if panel is not valid" do
        post '/slaps.json', :robin => '', :batman => ''
        last_response.status.should == 422
        MultiJson.decode(last_response.body).should == {
          'errors' => [
            'Robin must have something to say',
            'Batman never slaps Robin without a reason'
          ]
        }
      end
    end

    describe '/slaps/<hash>.jpg' do
      it "responds with 404 if Storage::NotFound is raised on read" do
        storage.stub(:retrieve).with('smoke').and_raise(Slapme::Storage::NotFound)
        get '/slaps/smoke.jpg'
        last_response.should be_not_found
      end

      it "sends image file when able to read from storage" do
        storage.stub(:retrieve).with('314159265').and_return('IMAGEDATA')
        get '/slaps/314159265.jpg'
        last_response.should be_ok
        last_response.content_type.should == 'image/jpeg'
        last_response.body.should == 'IMAGEDATA'
      end
    end

    def app
      Slapme::Server.tap do |server|
        server.set :run, false
      end
    end
  end
end
