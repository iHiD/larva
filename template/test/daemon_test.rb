require File.expand_path('../test_helper', __FILE__)

module LarvaSpawn
  class DaemonTest < Minitest::Test
    def test_the_daemon_starts
      config_dir = File.expand_path('', __FILE__)
      logfile = "log/test.log"
      LarvaSpawn::Daemon.start(config_dir: config_dir, logfile: logfile)
    end
  end
end
