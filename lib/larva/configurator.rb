require 'erb'

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

      after_configure if respond_to?(:after_configure)
    end

    private
    def parse_config_file(filename)
      contents = ERB.new(File.read(File.join(@config_dir, filename))).result
      hash = YAML::load(contents)
      hash.stringify_keys[@env].symbolize_keys
    rescue
      nil
    end
  end
end
