gem "minitest"
require "minitest/autorun"
require "minitest/pride"
require "minitest/mock"
require "mocha/setup"

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "larva"

module MeducationSDK
  def self.config
    @config ||= Struct.new(:access_id, :secret_key, :endpoint, :logger).new
    if block_given?
      yield @config
    else
      @config
    end
  end
end

class Minitest::Test

  def setup
    Fog.mock!
    Filum.setup('log/test.log')
    MeducationSDK.instance_variable_set(:@config, nil)
    Propono.config do |config|
      config.access_key = "test-access-key"
      config.secret_key = "test-secret-key"
      config.queue_region = "us-east-1"
      config.application_name = "MyApp"
      config.queue_suffix = nil

      config.logger = Filum.logger
    end
  end
end
