require File.expand_path('../../test_helper', __FILE__)

module LarvaSpawn
  class MediaFileProcessorTest < Minitest::Test
    def test_issue_or_update_badges_called_for_correct_message
      message = { entity: "media_file", action: "processed", media_file_id: 8 }
      LarvaSpawn::MediaFileProcessor.any_instance.expects(:do_one_thing)
      LarvaSpawn::MediaFileProcessor.any_instance.expects(:do_another_thing)
      LarvaSpawn::MediaFileProcessor.process(message)
    end
  end
end
