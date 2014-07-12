require 'larva'

require 'larva_spawn/configuration'
require 'larva_spawn/larva_spawn_error'
require 'larva_spawn/daemon'

module LarvaSpawn
  def self.config
    @config ||= Configuration.new
    if block_given?
      yield @config
    else
      @config
    end
  end
end
