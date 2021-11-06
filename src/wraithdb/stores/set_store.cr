module Wraith
  struct SetStore(T)
    getter store

    delegate :===, to: @store
    delegate :empty?, to: @store
    delegate :inspect, to: @store
    delegate :intersects?, to: @store
    delegate :proper_subset_of?, to: @store
    delegate :proper_superset_of?, to: @store
    delegate :size, to: @store
    delegate :subset_of?, to: @store
    delegate :|, to: @store

    def initialize
      @store = Set(T).new
    end

    def &(other : SetStore(T)) : SetStore(T)
      new_set = SetStore(T).new
      new_set.assign(store & other.store)
    end

    def +(other : SetStore(T)) : SetStore(T)
      new_set = SetStore(T).new
      new_set.assign(store + other.store)
    end

    def -(other : SetStore(T)) : SetStore(T)
      new_set = SetStore(T).new
      new_set.assign(store - other.store)
    end

    def ^(other : SetStore(T)) : SetStore(T)
      new_set = SetStore(T).new
      new_set.assign(store ^ other.store)
    end

    def ==(other : SetStore(T)) : Bool
      store == other.store
    end

    def add(object : T)

    end

    def add?(object : T) : Bool

    end

    def assign(new_set : Set(T)) : self
      @store = new_set
      self
    end

    def concat(elems) : self

    end

    def delete(object : T) : Bool

    end

    def subtract(other : Enumerable) : self

    end
  end
end
