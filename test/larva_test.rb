require File.expand_path('../test_helper', __FILE__)

module Larva
  class LarvaTest < Minitest::Test
    def test_mock_proxies_to_mocker
      Larva::Mocker.expects(:mock!)
      Larva.mock!
    end
  end
end
