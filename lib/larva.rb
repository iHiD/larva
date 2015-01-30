require 'filum'
require 'propono'

require_relative 'larva/hash_with_indifferent_access' unless defined?(HashWithIndifferentAccess)

require_relative 'larva/utils'
require_relative 'larva/configuration'
require_relative 'larva/configurator'
require_relative 'larva/mocker'
require_relative 'larva/listener'
require_relative 'larva/processor'
require_relative 'larva/worker_pool'
require_relative 'larva/daemon'
require_relative 'larva/message_replayer'

require_relative 'larva/daemon_creator'

module Larva
  class LarvaError < StandardError
  end

  def self.mock!
    Mocker.mock!
  end
end
