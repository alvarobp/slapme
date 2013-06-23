module Slapme
  class Panel
    attr_reader :robin, :batman, :errors

    def initialize(robin, batman)
      @robin = robin
      @batman = batman
      @errors = []
    end

    def hash_id
      Digest::SHA1.hexdigest(@robin + @batman)
    end

    def valid?
      validate_robin
      validate_batman
      errors.empty?
    end

    def canvas
      cnv = Slapme::Canvas.new(Slapme.background_image_path)
      cnv.add_caption(robin_caption)
      cnv.add_caption(batman_caption)
      cnv
    end

    def save
      if valid?
        storage.store(hash_id, canvas.render)
        true
      else
        false
      end
    end

    private

    def validate_robin
      if @robin.nil? || @robin.empty?
        "Robin must have something to say".tap do |message|
          @errors << message unless @errors.include?(message)
        end
      end
    end

    def validate_batman
      if @batman.nil? || @batman.empty?
        "Batman never slaps Robin without a reason".tap do |message|
          @errors << message unless @errors.include?(message)
        end
      end
    end

    def robin_caption
      Slapme::Caption.new(@robin.strip, 20, 4, 130, 55)
    end

    def batman_caption
      Slapme::Caption.new(@batman.strip, 182, 6, 130, 52)
    end

    def storage
      Slapme.storage
    end
  end
end
