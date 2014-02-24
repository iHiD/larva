require File.expand_path('../test_helper', __FILE__)

module Larva
  class DaemonTest < Minitest::Test
    def test_workerpool_is_started
      processors = {foo: 'bar'}
      Configurator.stubs(:configure)
      WorkerPool.expects(:start).with(processors)
      Daemon.start(processors, logfile: "./log/foo.log", config_dir: config_dir)
    end

    def test_configurator_is_called
      options = {logfile: "./log/foo.log", config_dir: config_dir}
      Configurator.expects(:configure).with(options)
      Daemon.start({}, options)
    end
  end
end
