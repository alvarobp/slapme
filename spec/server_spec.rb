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

    def app
      Slapme::Server.tap do |server|
        server.set :run, false
      end
    end
  end
end