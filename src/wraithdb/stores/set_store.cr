module Wraith
  struct SetStore(T)
    getter store

    def initialize
      @store = Set(T)
    end
  end
end
