module Larva
  class Mocker
    def self.mock!
      Filum.setup('./log/test.log')
      Propono::Publisher.any_instance.stubs(:publish_via_sns)

      Propono.config do |config|
        config.logger = Filum.logger
      end

      after_mock if respond_to?(:after_mock)
    end
  end
end
