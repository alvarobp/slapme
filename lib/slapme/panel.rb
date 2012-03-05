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