module Wraith
  struct ArrayStore(T)
    getter store

    def initialize
      @store = [] of T
    end
  end
end
