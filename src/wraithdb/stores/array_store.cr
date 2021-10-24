module Wraith
  struct ArrayStore(T)
    getter store

    delegate :[], to: @store
    delegate :all?, to: @store
    delegate :any?, to: @store
    delegate :compact, to: @store
    delegate :count, to: @store
    delegate :each, to: @store
    delegate :each_with_index, to: @store
    delegate :first, to: @store
    delegate :index, to: @store
    delegate :join, to: @store
    delegate :last, to: @store
    delegate :map, to: @store
    delegate :max, to: @store
    delegate :min, to: @store
    delegate :minmax, to: @store
    delegate :reject, to: @store
    delegate :reverse, to: @store
    delegate :sample, to: @store
    delegate :select, to: @store
    delegate :shuffle, to: @store
    delegate :size, to: @store
    delegate :sum, to: @store
    delegate :uniq, to: @store

    def initialize
      @store = [] of T
    end
  end
end
