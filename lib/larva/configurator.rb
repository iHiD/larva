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

      propono_config = parse_config_file('propono.yml')

      propono_setup(propono_config)

      after_configure if respond_to?(:after_configure)
    end

    private
    def parse_config_file(filename)
      contents = ERB.new(File.read(File.join(@config_dir, filename))).result
      hash = YAML::load(contents)
      hash.stringify_keys[@env].symbolize_keys
    rescue
      Hash.new()
    end

    def propono_setup(propono_config)
      Propono.config do |config|
        config.queue_region = propono_config.delete(:region) # Backwards compatible with region key instead of queue_region
        config.logger       = Filum.logger

        propono_config.each { |key, value| config.send("#{key}=", value) }
      end
    end
  end
end
