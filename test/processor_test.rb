require File.expand_path('../test_helper', __FILE__)

module Larva
  class ProcessorTest < Minitest::Test
    def test_initialize_should_extract_action_and_entity
      entity = "media_file"
      action = "processed"
      message = {entity: entity, action: action, media_file_id: "8"}
      processor = Processor.new(message)
      assert_equal entity, processor.entity
      assert_equal action, processor.action
    end

    class GoodProcessor < Processor
      def process
        true
      end
    end

    class BadProcessor < Processor
      def process
        false
      end
    end

    def test_process_logs_message
      message = {entity: "media_file", action: "processed", media_file_id: "8"}
      output = "Processing message: #{message}"
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with(output)
      GoodProcessor.process(message)
    end

    def test_process_logs_success
      message = {entity: "media_file", action: "processed", media_file_id: "8"}
      output = "Message Processed: #{message}"
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with(output)
      GoodProcessor.process(message)
    end

    def test_process_logs_message
      entity = "media_file"
      action = "processed"
      message = {entity: entity, action: action, media_file_id: "8"}
      output = "Unrecognized event type, entity: #{entity} action: #{action}."

      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with(output)
      BadProcessor.process(message)
    end
  end
end

