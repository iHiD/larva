module Larva
  class WorkerPool
    def self.start(processors)
      new(processors).start
    end

    attr_reader :processors, :workers
    def initialize(processors)
      @processors = processors
    end

    def start
      start_workers
      keep_workers_alive if workers.count > 0
    end

    private
    def start_workers
      logger.info "Starting threads."
      @workers = processors.map do |topic, processor|
        Thread.new { start_worker(topic, processor) }
      end
      logger.info "Threads Started."
    end

    def start_worker(topic, processor)
      Larva::Listener.listen(topic, processor)
    rescue => e
      logger.error "Unexpected listener termination: #{e} #{e.backtrace}"
    end

    def keep_workers_alive
      sleep(1) while workers.all? { |t| t.alive?  }
      logger.error "Some threads have died"
    end

    def logger
      Propono.config.logger
    end
  end
end
