module Larva
  class Daemon
    def self.start(*args)
      daemon = new(*args)
      daemon.configure
      daemon.start
      daemon
    end

    # Allowed Options:
    #   :env - Defaults to development
    def initialize(processors, options = {})
      @processors = processors
      @options = options
    end

    def start
      Filum.logger.info "Starting Workerpool"
      Larva::WorkerPool.start(@processors)
      Filum.logger.info "Workerpool Finished"
    end

    def configure
      Configurator.configure(@options)
    end
  end
end
