require 'sinatra'
require 'multi_json'

module Slapme
  class Server < Sinatra::Base
    set :root, Slapme.root

    get '/' do
      index_path = File.join(self.class.public_folder, 'index.html')
      if File.exists?(index_path)
        File.read(index_path)
      else
        status 404
      end
    end

    post '/slaps.json' do
      content_type 'application/json'
      if panel.save
        MultiJson.encode :url => slap_url(panel.hash_id)
      else
        body MultiJson.encode(:errors => panel.errors)
        status 422
      end
    end

    get "/slaps/:hash.jpg" do
      hash = params[:hash]
      begin
        image_data = Slapme.storage.retrieve(hash)
        content_type :jpeg
        image_data
      rescue Slapme::Storage::NotFound
        status 404
      end
    end

    helpers do
      def slap_url(hash)
        "#{Slapme.base_uri}/slaps/#{filename(hash)}"
      end
    end

    private

    def panel
      @panel ||= Slapme::Panel.new(params[:robin], params[:batman])
    end

    def filename(hash)
      "#{hash}.jpg"
    end
  end
end
