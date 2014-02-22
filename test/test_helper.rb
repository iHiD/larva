gem "minitest"
require "minitest/autorun"
require "minitest/pride"
require "minitest/mock"
require "mocha/setup"

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "larva"

class Minitest::Test
  def setup
    Fog.mock!
    Filum.config.logfile = 'log/test.log'
    Propono.config do |config|
      config.access_key = "test-access-key"
      config.secret_key = "test-secret-key"
      config.queue_region = "us-east-1"
      config.application_name = "MyApp"

      config.logger = Filum.logger
    end
  end
end
