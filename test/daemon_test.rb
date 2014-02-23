require File.expand_path('../test_helper', __FILE__)

module Larva
  class DaemonTest < Minitest::Test
    def config_dir
      File.expand_path('../sample_config', __FILE__)
    end

    def logfile
      "log/test.log"
    end

    def test_workerpool_is_started
      processors = {foo: 'bar'}
      Larva::WorkerPool.expects(:start).with(processors)
      Daemon.start(processors, logfile: "./log/foo.log", config_dir: config_dir)
    end

    def test_logfile_is_compulsary
      assert_raises(LarvaError, "Please provide :logfile via options") do
        Daemon.start({}, config_dir: config_dir)
      end
    end

    def test_config_dir_is_compulsary
      assert_raises(LarvaError, "Please provide :config_dir via options") do
        Daemon.start({}, logfile: logfile)
      end
    end

    def test_filum_gets_config
      Daemon.start({}, logfile: logfile, config_dir: config_dir)
      assert_equal logfile, Filum.logger.logfile
    end

    def test_meducation_sdk_gets_config
      Daemon.start({}, config_dir: config_dir, logfile: logfile)
      assert_equal "Daemon", MeducationSDK.config.access_id
      assert_equal "foobar", MeducationSDK.config.secret_key
      assert_equal Filum.logger, MeducationSDK.config.logger
    end

    def test_meducation_sdk_gets_config_with_env
      Daemon.start({}, config_dir: config_dir, logfile: logfile, env: 'production')
      assert_equal "Daemon", MeducationSDK.config.access_id
      assert_equal nil, MeducationSDK.config.secret_key
      assert_equal Filum.logger, MeducationSDK.config.logger
    end

    def test_propono_gets_config
      Daemon.start({}, config_dir: config_dir, logfile: logfile)
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
      Daemon.start({}, config_dir: config_dir, logfile: logfile, env: 'production')
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
