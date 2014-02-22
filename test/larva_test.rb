require File.expand_path('../test_helper', __FILE__)

module Larva
  class LarvaTest < Minitest::Test
    def test_shit_happens
      topic, message = "Foo", "Bar"
      Propono::Publisher.expects(:publish).with(topic, message, {})
      Propono.publish(topic, message)
    end
  end
end
