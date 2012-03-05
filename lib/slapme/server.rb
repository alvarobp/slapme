require 'sinatra'
require 'multi_json'

module Slapme
  class Server < Sinatra::Base

    post '/slaps.json' do
      content_type 'application/json'

      if filename = panel.save
        MultiJson.encode :url => image_url(filename)
      else
        body MultiJson.encode(:errors => panel.errors)
        status 422
      end
    end

    helpers do
      def image_url(filename)
        "#{Slapme.base_uri}/slaps/#{filename}"
      end
    end

    private

    def panel
      @panel ||= Slapme::Panel.new(params[:robin], params[:batman])
    end

  end
end