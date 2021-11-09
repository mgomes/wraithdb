module Wraith
  struct SetStore(T)
    getter store

    delegate :each, to: @store
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
      store.add(object)
    end

    def add?(object : T) : Bool
      store.add?(object)
    end

    def assign(new_set : Set(T)) : self
      @store = new_set.clone
      self
    end

    def concat(elems : SetStore(T)) : self
      store.concat(elems.store)
      self
    end

    def delete(object : T) : Bool
      store.delete(object)
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

    def subtract(other : SetStore(T)) : self
      store.subtract(other.store)
      self
    end

    def subtract(other : Enumerable) : self
      store.subtract(other)
      self
    end

    def |(other : SetStore(T)) : SetStore(T)
      new_set = SetStore(T).new
      new_set.assign(store | other.store)
    end
  end
end
