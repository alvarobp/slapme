require 'slapme'
require 'slapme/server'
require 'rack/test'

module Slapme
  describe Server do
    include Rack::Test::Methods

    before { Slapme.stub(:base_uri).and_return 'http://slapme.test' }

    describe '/slaps.json' do
      it "responds with slap url if panel is valid" do
        robin_says = 'Hey Batman, do you think...'
        batman_says = 'Shut up for once'
        Slapme::Panel.stub(:new).with(robin_says, batman_says) {
          stub(:save => 'panelhash.jpg')
        }

        post '/slaps.json', :robin => robin_says, :batman => batman_says

        last_response.should be_ok
        MultiJson.decode(last_response.body).should == {
          'url' => 'http://slapme.test/slaps/panelhash.jpg'
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
      it "responds with 404 if image file for hash does not exist" do
        Slapme.stub(:images_path) { '/images' }
        app.stub(:image_file_exists?).with('smoke') { false }
        get '/slaps/smoke.jpg'
        last_response.should be_not_found
      end

      it "sends image file" do
        Slapme.stub(:images_path) { '/images' }
        Slapme::Server.any_instance.stub(:image_file_exists?).
          with('314159265') { true }
        # Nasty!
        Slapme::Server.any_instance.should_receive(:send_file).
          with('/images/314159265.jpg', :type => :jpg) { 'lastexpectedthing' }

        get '/slaps/314159265.jpg'

        last_response.should be_ok
        last_response.body.should == 'lastexpectedthing'
      end
    end

    def app
      Slapme::Server.tap do |server|
        server.set :run, false
      end
    end
  end
end