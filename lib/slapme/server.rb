require 'sinatra'
require 'multi_json'

module Slapme
  class Server < Sinatra::Base

    post '/slaps.json' do
      content_type 'application/json'

      if filename = panel.save
        MultiJson.encode :url => slap_url(filename)
      else
        body MultiJson.encode(:errors => panel.errors)
        status 422
      end
    end

    get "/slaps/:hash.jpg" do
      if image_file_exists?(params[:hash])
        send_file image_path(params[:hash]), :type => :jpg
      else
        status 404
      end
    end

    helpers do
      def slap_url(filename)
        "#{Slapme.base_uri}/slaps/#{filename}"
      end
    end

    private

    def panel
      @panel ||= Slapme::Panel.new(params[:robin], params[:batman])
    end

    def image_path(hash)
      File.join Slapme.images_path, "#{hash}.jpg"
    end

    def image_file_exists?(hash)
      File.exists? image_path(hash)
    end
  end
end