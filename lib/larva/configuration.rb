module Larva
  class LarvaConfigurationError < StandardError
  end

  class Configuration
    attr_accessor :logger

    def initialize
      @logger = Filum.logger
    end
  end
end
