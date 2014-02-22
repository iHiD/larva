require File.expand_path('../test_helper', __FILE__)

module Larva
  class ProcessorTest < Minitest::Test

    class MetaProcessor < Processor
      def media_file_processed; end
    end

    class NormalProcessor < Processor
      def process; end
    end

    def test_initialize_should_extract_action_and_entity
      entity = "media_file"
      action = "processed"
      message = {entity: entity, action: action, media_file_id: "8"}
      processor = Processor.new(message)
      assert_equal entity, processor.entity
      assert_equal action, processor.action
    end

    def test_process_logs_message
      message = {entity: "media_file", action: "processed", media_file_id: "8"}
      output = "Processing message: #{message}"
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with(output)
      NormalProcessor.process(message)
    end

    def test_process_calls_meta_method
      message = {entity: "media_file", action: "processed", media_file_id: "8"}
      MetaProcessor.any_instance.expects(:media_file_processed)
      MetaProcessor.process(message)
    end

    def test_process_is_called_if_no_meta_method_exists
      message = {entity: "media_file", action: "processed", media_file_id: "8"}
      NormalProcessor.expects(:process)
      NormalProcessor.process(message)
    end

    def test_process_logs_success
      message = {entity: "media_file", action: "processed", media_file_id: "8"}
      output = "Message Processed: #{message}"
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with(output)
      NormalProcessor.any_instance.expects(:process).returns(true)
      NormalProcessor.process(message)
    end

    def test_process_logs_error_with_false_handler
      entity = "media_file"
      action = "processed"
      message = {entity: entity, action: action, media_file_id: "8"}
      output = "Unrecognized event type, entity: #{entity} action: #{action}."

      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with(output)
      NormalProcessor.any_instance.expects(:process).returns(false)
      NormalProcessor.process(message)
    end

    def test_process_logs_error_with_no_handler
      entity = "comment"
      action = "created"
      message = {entity: entity, action: action, media_file_id: "8"}
      output = "Unrecognized event type, entity: #{entity} action: #{action}."

      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with(output)
      MetaProcessor.process(message)
    end
  end
end

