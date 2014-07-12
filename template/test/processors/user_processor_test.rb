require File.expand_path('../../test_helper', __FILE__)

module LarvaSpawn
  class UserProcessorTest < Minitest::Test
    def test_everything_is_wired_up_correctly
      message = { entity: "user", action: "created", foo: 'bar'}
      LarvaSpawn::UserProcessor.any_instance.expects(:do_something).with('bar')
      LarvaSpawn::UserProcessor.process(message)
    end
  end
end
