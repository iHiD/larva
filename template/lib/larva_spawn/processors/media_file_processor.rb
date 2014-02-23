module LarvaSpawn
  class MediaFileProcessor < Larva::Processor
    def media_file_processed
      do_one_thing
      do_another_thing
    end

    private
    def do_one_thing
    end
    def do_another_thing
    end
  end
end

