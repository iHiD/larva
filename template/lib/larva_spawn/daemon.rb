require 'larva_spawn/processors/media_file_processor'

module LarvaSpawn
  class Daemon < Larva::Daemon
    def initialize(options = {})
      processors = {
        media_file: MediaFileProcessor
      }
      super(processors, options)
    end
  end
end
