require File.expand_path('../test_helper', __FILE__)

module Larva
  class DaemonTest < Minitest::Test
    def test_workerpool_is_started
      processors = {foo: 'bar'}
      Larva::WorkerPool.expects(:start).with(processors)
      Daemon.start(nil, "./log/foo.log", processors)
    end

    def test_filum_gets_config
      logfile = "log/test.log"
      Daemon.start(nil, logfile, {})
      assert_equal logfile, Filum.logger.logfile
    end

    def test_meducation_sdk_gets_config
      logfile = "log/test.log"
      Daemon.start(File.expand_path('../sample_config', __FILE__), "./log/foo.log", {})
      assert_equal "Daemon", MeducationSDK.config.access_id
      assert_equal "foobar", MeducationSDK.config.secret_key
      assert_equal Filum.logger, MeducationSDK.config.logger
    end

    def test_meducation_sdk_gets_config_with_env
      logfile = "log/test.log"
      Daemon.start(File.expand_path('../sample_config', __FILE__), "./log/foo.log", {}, env: 'production')
      assert_equal "Daemon", MeducationSDK.config.access_id
      assert_equal nil, MeducationSDK.config.secret_key
      assert_equal Filum.logger, MeducationSDK.config.logger
    end

    def test_propono_gets_config
      logfile = "log/test.log"
      Daemon.start(File.expand_path('../sample_config', __FILE__), "./log/foo.log", {})
      assert_equal "BADASSDEVKEY", Propono.config.access_key
      assert_equal "SCARYDEVSECRET", Propono.config.secret_key
      assert_equal "eu-west-1", Propono.config.queue_region
      assert_equal "development_daemon", Propono.config.application_name
      assert_equal "-dev", Propono.config.queue_suffix
      assert_equal "pergo.meducation.net", Propono.config.udp_host
      assert_equal "9732", Propono.config.udp_port
      assert_equal Filum.logger, Propono.config.logger
    end

    def test_propono_gets_config_with_env
      logfile = "log/test.log"
      Daemon.start(File.expand_path('../sample_config', __FILE__), "./log/foo.log", {}, {env: 'production'})
      assert_equal "BADASSPRODUCTIONKEY", Propono.config.access_key
      assert_equal "SCARYPRODUCTIONSECRET", Propono.config.secret_key
      assert_equal "eu-west-1", Propono.config.queue_region
      assert_equal "daemon", Propono.config.application_name
      assert_equal nil, Propono.config.queue_suffix
      assert_equal "pergo.meducation.net", Propono.config.udp_host
      assert_equal "9732", Propono.config.udp_port
      assert_equal Filum.logger, Propono.config.logger
    end
  end
end
