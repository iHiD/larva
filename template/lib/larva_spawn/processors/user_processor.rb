module LarvaSpawn
  class UserProcessor < Larva::Processor
    def user_created
      do_something(message[:foo])
    end

    private
    def do_something(foo)
    end
  end
end

