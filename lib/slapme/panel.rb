module Slapme
  class Panel

    attr_accessor :robin, :batman
    attr_reader :errors

    def initialize(robin, batman)
      @robin = robin
      @batman = batman
      @errors = []
    end

    def valid?
      validate_robin
      validate_batman
      errors.empty?
    end

    def canvas
      Slapme::Canvas.new(Slapme.background_image_path).tap do |canv|
        canv.captions << Slapme::Caption.new(
          @robin.strip, 20, 4, 130, 55
        )
        canv.captions << Slapme::Caption.new(
          @batman.strip, 182, 6, 130, 52
        )
      end
    end

    def save
      if valid?
        storage = Slapme::Storage.new(self)
        storage.store
        storage.filename
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
  end
end