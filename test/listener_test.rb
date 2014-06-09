require File.expand_path('../test_helper', __FILE__)

module Larva
  class ListenerTest < Minitest::Test
    def test_listen_to_queue_is_called
      topic_name = "Foo"
      Propono.expects(:listen_to_queue).with("#{topic_name}")
      Larva::Listener.listen(topic_name, nil)
    end

    def test_listener_logs_listening_message
      topic_name = "Foo"
      message = "Starting to listen to queue #{topic_name}"
      Propono.config.logger.expects(:info).with(message)
      Propono.stubs(:listen_to_queue)
      Larva::Listener.listen(topic_name, nil)
    end

    def test_listener_changes_context
      context = {id: "34sdf"}
      Propono.config.logger.expects(:context_id=).with(context[:id])
      Propono.stubs(:listen_to_queue).yields(nil, context)
      Larva::Listener.listen("foobar", mock(process: nil))
    end

    def test_listener_logs_message
      message = {foo: 'bar'}
      context = {id: "34sdf"}
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with("Received message: #{message}")
      Propono.stubs(:listen_to_queue).yields(message, context)
      Larva::Listener.listen("foobar", mock(process: nil))
    end

    def test_processor_is_called_with_message
      processor = mock
      message = {foo: 'bar'}
      processor.expects(:process).with(message)
      Propono.expects(:listen_to_queue).yields(message, {})
      Larva::Listener.listen("foobar", processor)
    end
  end
end
