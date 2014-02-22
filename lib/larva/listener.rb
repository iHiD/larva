module Larva
  class Listener

    def self.listen(topic_name, processor, queue_suffix)
      new(topic_name, processor, queue_suffix).listen
    end

    attr_reader :topic_name, :processor, :queue_suffix
    def initialize(topic_name, processor, queue_suffix)
      @topic_name = topic_name
      @processor = processor
      @queue_suffix = queue_suffix
    end

    def listen
      Propono.config.logger.info "Starting to listen to queue #{topic_name}#{queue_suffix}"
      Propono.listen_to_queue("#{topic_name}#{queue_suffix}") do |message, context|
        Propono.config.logger.context_id = context[:id]
        Propono.config.logger.info "Received message: #{message}"
        processor.process(message)
      end
    end
  end
end
