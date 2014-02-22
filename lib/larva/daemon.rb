module Larva
  class Daemon
    def self.start(*args)
      daemon = new(*args)
      daemon.configure
      daemon.start
      daemon
    end

    # Allowed Options:
    #   :env - Defaults to development
    #   :meducation_sdk_secret_key - Defauls to looking in config file
    def initialize(config_dir, logfile, processors, options = {})
      @config_dir = config_dir
      @logfile = logfile
      @processors = processors
      @options = options
      @env = options.fetch(:env, "development")
    end

    def start
      Larva::WorkerPool.start(@processors)
    end

    def configure
      Filum.setup(@logfile)

      if meducation_sdk_config = parse_config_file('meducation-sdk.yml')
        MeducationSDK.config do |config|
          config.access_id  = meducation_sdk_config[:access_id]
          config.secret_key = @options[:meducation_sdk_secret_key] || meducation_sdk_config[:secret_key]
          config.logger     = Filum.logger
        end
      end

      if propono_config = parse_config_file('propono.yml')
        Propono.config do |config|
          config.use_iam_profile  = propono_config[:use_iam_profile]
          config.access_key       = propono_config[:access_key]
          config.secret_key       = propono_config[:secret_key]
          config.queue_region     = propono_config[:region]
          config.application_name = propono_config[:application_name]
          config.queue_suffix     = propono_config[:queue_suffix]
          config.udp_host         = "pergo.meducation.net"
          config.udp_port         = "9732"
          config.logger           = Filum.logger
        end
      end
    end

    def parse_config_file(filename)
      YAML::load(ERB.new(File.read("#{@config_dir}/#{filename}")).result).stringify_keys[@env].symbolize_keys
    rescue
      nil
    end
  end
end
