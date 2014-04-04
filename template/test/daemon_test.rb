require File.expand_path('../test_helper', __FILE__)

module LarvaSpawn
  class DaemonTest < Minitest::Test
    def test_the_daemon_starts
      config_dir = File.expand_path('../../config', __FILE__)
      logfile = "log/test.log"
      Larva::WorkerPool.any_instance.stubs(keep_workers_alive: true)
      LarvaSpawn::Daemon.start(config_dir: config_dir, logfile: logfile)
    end
  end
end
