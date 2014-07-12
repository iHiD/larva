module Larva
  class Processor
    def self.process(message)
      new(message).process_with_logging
    end

    attr_accessor :message, :action, :entity, :id
    def initialize(raw_message)
      @message = HashWithIndifferentAccess.new(raw_message)
      @action = message[:action]
      @entity = message[:entity]
      @id = message[:id]
    end

    def process_with_logging
      Propono.config.logger.info "Processing message: #{message}"
      meta_process || normal_process
    end

    private

    def meta_process
      meta_method = "#{entity}_#{action}"
      if respond_to? meta_method
        self.send(meta_method)
        true
      else
        false
      end
    end

    def normal_process
      if respond_to?(:process) && self.process
        Propono.config.logger.info "Message Processed: #{message}"
      else
        Propono.config.logger.info "Unrecognized event type, entity: #{entity} action: #{action}."
      end
    end
  end
end
