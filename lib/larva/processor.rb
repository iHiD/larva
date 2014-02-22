module Larva
  class Processor
    def self.process(message)
      new(message).process_with_logging
    end

    attr_accessor :message, :action, :entity, :id
    def initialize(message)
      @message = message
      @action = message[:action]
      @entity = message[:entity]
      @id = message[:id]
    end

    def process_with_logging
      Propono.config.logger.info "Processing message: #{message}"
      if self.process
        Propono.config.logger.info "Message Processed: #{message}"
      else
        Propono.config.logger.info "Unrecognized event type, entity: #{entity} action: #{action}."
      end
    end
  end
end
