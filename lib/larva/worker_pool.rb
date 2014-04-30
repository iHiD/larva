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
      @running = true
      start_workers
      keep_workers_alive if workers.count > 0 
    end
   
    def stop
      logger.info "Request to stop worker pool accepted"
      @running = false
    end

    private
    def start_workers
      logger.info "Starting #{processors.count} threads."
      @workers = processors.map do |topic, processor|
        worker = Thread.new { start_worker(topic, processor) }
        worker[:name] = "Listener for #{topic}"
        worker
      end
      logger.info "#{workers.count} threads started."
    end

    def start_worker(topic, processor)
      Larva::Listener.listen(topic, processor)
    rescue => e
      logger.error "Unexpected listener termination: #{e} #{e.backtrace}"
    end

    def keep_workers_alive
      while @running && workers.all? { |t| t.alive?  }
        logger.info 'All threads are alive.'
        sleep(60) 
      end

      logger.error 'Some threads have died:'
      workers.each do |worker|
        logger.error "#{worker[:name]} was #{worker.alive? ? 'alive' : 'dead'}"
      end
      raise StandardError.new('Some threads have died') if @running
    end

    def logger
      Propono.config.logger
    end
  end
end
