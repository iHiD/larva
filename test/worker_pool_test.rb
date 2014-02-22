require File.expand_path('../test_helper', __FILE__)

module Larva
  class WorkerPoolTest < Minitest::Test
    def test_should_complete_for_no_processors
      WorkerPool.start({})
    end

    def test_process_logs_start_message
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with("Starting threads.")
      WorkerPool.start({})
    end

    def test_process_logs_end_message
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with("Threads Started.")
      WorkerPool.start({})
    end

    def test_start_worker_logs_exception
      Larva::Listener.expects(:listen).raises(RuntimeError)
      Propono.config.logger.expects(:error).with do |error|
        error.start_with?("Unexpected listener termination:")
      end
      Propono.config.logger.expects(:error).with('Some threads have died')
      WorkerPool.start({nil => nil})
    end

    def test_listen_is_called_correctly
      topic_name = "Foo"
      processor = mock
      Larva::Listener.expects(:listen).with(topic_name, processor)
      WorkerPool.start({topic_name => processor})
    end
  end
end
