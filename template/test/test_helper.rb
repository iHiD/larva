gem "minitest"
require "minitest/autorun"
require "minitest/pride"
require "minitest/mock"
require "mocha/setup"

unit = File.expand_path('../../test/unit', __FILE__)
$LOAD_PATH.unshift(unit) unless $LOAD_PATH.include?(unit)

lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'larva_spawn'

#MeducationSDK.mock!

class Minitest::Test
  def setup
    super
    Larva.mock!
  end
end
