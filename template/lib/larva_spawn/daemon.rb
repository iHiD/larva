require 'larva_spawn/processors/user_processor'

module LarvaSpawn
  class Daemon < Larva::Daemon
    def initialize(options = {})
      processors = {
        user: UserProcessor
      }
      super(processors, options)
    end
  end
end
