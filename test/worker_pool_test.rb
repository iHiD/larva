require File.expand_path('../test_helper', __FILE__)

module Larva
  class WorkerPoolTest < Minitest::Test
    def test_should_complete_for_no_processors
      WorkerPool.start({})
    end

    def test_process_logs_start_and_end_messages
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with("Starting 0 threads.")
      Propono.config.logger.expects(:info).with("0 threads started.")
      WorkerPool.start({})
    end

    def test_start_worker_logs_exception
      Larva::Listener.expects(:listen).raises(RuntimeError)
      Propono.config.logger.expects(:error).with do |error|
        error.start_with?("Unexpected listener termination:")
      end
      Propono.config.logger.expects(:error).with('Listener for qux was dead')
      Propono.config.logger.expects(:error).with('Some threads have died:')
      pool = WorkerPool.new({'qux' => nil})
      pool.stubs(:sleep)
      err = assert_raises(StandardError) { pool.start }
      assert_equal 'Some threads have died', err.message
    end

    def test_listen_is_called_correctly
      Propono.config.logger.stubs(:info)
      Propono.config.logger.expects(:info).with("All threads are alive.")

      topic_name = "Foo"
      processor = mock
      Larva::Listener.expects(:listen).with(topic_name, processor)
      pool = WorkerPool.new({topic_name => processor})

      pool.expects(:sleep).with(60).at_least_once

      Thread.any_instance.stubs(alive?: true)

      Thread.new do
        while true 
          sleep(1)
          pool.stop
        end
      end

      pool.start
    end
  end
end
