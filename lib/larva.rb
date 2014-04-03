require 'active_support/core_ext'
require 'filum'
require 'propono'

require 'larva/configuration'
require 'larva/configurator'
require 'larva/mocker'
require 'larva/listener'
require 'larva/processor'
require 'larva/worker_pool'
require 'larva/daemon'
require 'larva/message_replayer'

module Larva
  class LarvaError < StandardError
  end

  def self.mock!
    Mocker.mock!
  end
end
