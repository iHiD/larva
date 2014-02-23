require 'active_support/core_ext'
require 'filum'
require 'propono'

require 'larva/mocker'
require 'larva/listener'
require 'larva/processor'
require 'larva/worker_pool'
require 'larva/daemon'

module Larva
  def mock!
    Mocker.mock!
  end
end
