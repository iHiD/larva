module Larva
  class Configurator

    def self.configure(options = {})
      c = new(options)
      c.configure
      c
    end

    def initialize(options = {})
      @options = options
      @config_dir = options.fetch(:config_dir) {raise LarvaError.new("Please provide :config_dir via options")}
      @logfile = options.fetch(:logfile) {raise LarvaError.new("Please provide :logfile via options")}
      @env = (options[:env] || "development").to_s
    end

    def configure
      Filum.setup(@logfile)
      Filum.logger.info "Configuring Daemon"

      if meducation_sdk_config = parse_config_file('meducation-sdk.yml')
        MeducationSDK.config do |config|
          config.access_id  = meducation_sdk_config[:access_id]

          # Don't use fetch for these as nil values might be deliberately passed it
          config.secret_key = @options[:meducation_sdk_secret_key] || meducation_sdk_config[:secret_key]
          config.endpoint   = @options[:meducation_sdk_endpoint ] || "http://localhost:3000/spi" if @env == 'development'
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

    private
    def parse_config_file(filename)
      contents = File.read("#{@config_dir}/#{filename}")
      hash = YAML::load(contents)
      hash.stringify_keys[@env].symbolize_keys
    rescue
      nil
    end
  end
end
