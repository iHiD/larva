require File.expand_path('../test_helper', __FILE__)

module Larva
  class MockerTest < Minitest::Test
    def test_filum_is_setup
      Filum.expects(:setup).with('./log/test.log')
      Mocker.mock!
    end

    def test_propono_publisher_is_stubbed
      any_instance = mock()
      any_instance.expects(:stubs).with(:publish_via_sns)
      Propono::Publisher.expects(:any_instance).returns(any_instance)
      Mocker.mock!
    end

    def test_loquor_is_setup
      Mocker.mock!
      assert_equal "http://localhost:3000/spi", MeducationSDK.config.endpoint
      assert_equal "localhost", MeducationSDK.config.recommender_host
      assert_equal "Daemon", MeducationSDK.config.access_id
      assert_equal "foobar", MeducationSDK.config.secret_key
      assert_equal Filum.logger, MeducationSDK.config.logger
    end

    def test_propono_is_configured
      Mocker.mock!
      assert_equal Filum.logger, Propono.config.logger
    end
  end
end
