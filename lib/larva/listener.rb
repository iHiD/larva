module Larva
  class Listener

    def self.listen(topic_name, processor)
      new(topic_name, processor).listen
    end

    attr_reader :topic_name, :processor
    def initialize(topic_name, processor)
      @topic_name = topic_name
      @processor = processor
    end

    def listen
      queue_name = "#{topic_name}#{Propono.config.queue_suffix}"
      Propono.config.logger.info "Starting to listen to queue #{queue_name}"
      Propono.listen_to_queue("#{queue_name}") do |message, context|
        Propono.config.logger.context_id = context[:id]
        Propono.config.logger.info "Received message: #{message}"
        processor.process(message)
      end
    end
  end
end
