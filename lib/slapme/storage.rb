module Slapme
  class Storage
    def initialize(panel)
      @panel = panel
    end

    def store
      @panel.canvas.render.write(filepath)
    end

    def hash
      Digest::SHA1.hexdigest(@panel.robin + @panel.batman)
    end

    def filepath
      File.join(Slapme.images_path, filename)
    end

    private

    def filename
      "#{hash}.jpg"
    end
  end
end