module Larva
  class WorkerPool
    def self.start(processors, queue_suffix)
      new(processors, queue_suffix).start
    end

    attr_reader :processors, :queue_suffix, :workers
    def initialize(processors, queue_suffix)
      @processors = processors
      @queue_suffix = queue_suffix
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
      Larva::Listener.listen(topic, processor, queue_suffix)
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
