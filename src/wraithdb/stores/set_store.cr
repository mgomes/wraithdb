module Wraith
  struct SetStore(T)
    getter store

    delegate :empty?, to: @store
    delegate :includes?, to: @store
    delegate :inspect, to: @store
    delegate :size, to: @store

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

    def ===(other : SetStore(T)) : Bool
      store === other.store
    end

    def add(object : T)

    end

    def add?(object : T) : Bool

    end

    def assign(new_set : Set(T)) : self
      @store = new_set.clone
      self
    end

    def concat(elems) : self

    end

    def delete(object : T) : Bool

    end

    def intersects?(other : SetStore(T)) : Bool
      self.store.intersects?(other.store)
    end

    def proper_subset_of?(other : SetStore(T)) : Bool
      self.store.proper_subset_of?(other.store)
    end

    def proper_superset_of?(other : SetStore(T)) : Bool
      self.store.proper_superset_of?(other.store)
    end

    def subset_of?(other : SetStore(T)) : Bool
      self.store.subset_of?(other.store)
    end

    def subtract(other : Enumerable) : self

    end

    def |(other : SetStore(T)) : SetStore(T)
      new_set = SetStore(T).new
      new_set.assign(store | other.store)
    end
  end
end
