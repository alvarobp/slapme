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
      if @robin.nil? || @robin.empty?
        "Robin must have something to say".tap do |message|
          @errors << message unless @errors.include?(message)
        end
      end
      if @batman.nil? || @batman.empty?
        "Batman never slaps Robin without a reason".tap do |message|
          @errors << message unless @errors.include?(message)
        end
      end
      @errors.empty?
    end
    
  end
end