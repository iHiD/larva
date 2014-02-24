require File.expand_path('../test_helper', __FILE__)

module Larva
  class ConfigurationTest < Minitest::Test
    def test_configuration_sets_logger_correctly
      assert_equal Filum.logger, Configuration.new.logger
    end

    def test_configuration_sets_logger_correctly
      logger = mock
      config = Configuration.new
      config.logger = logger
      assert_equal logger, config.logger
    end
  end
end
