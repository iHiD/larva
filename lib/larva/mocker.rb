module Larva
  class Mocker
    def self.mock!
      Filum.setup('./log/test.log')
      Propono::Publisher.any_instance.stubs(:publish_via_sns)

      if const_defined?("MeducationSDK")
        MeducationSDK.config do |config|
          config.endpoint   = "http://localhost:3000/spi"
          config.access_id  = "Daemon"
          config.secret_key = "foobar"
          config.logger     = Filum.logger
        end
      end

      Propono.config do |config|
        config.logger = Filum.logger
      end
    end
  end
end
