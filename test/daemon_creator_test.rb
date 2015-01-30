require File.expand_path('../test_helper', __FILE__)

module Larva
  class DaemonCreatorTest < Minitest::Test
    def test_things_are_called
      pwd = "pwd"
      daemon_name = "foobar"
      creator = DaemonCreator.new(pwd, daemon_name)
      FileUtils.expects(:cp_r)
      creator.expects(:rename_directories)
      creator.expects(:rename_files)
      creator.expects(:rename_file_contents)
      creator.expects(:git_it_up)
      creator.create
    end
  end
end
