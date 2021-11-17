require "../atomically"

module Wraith
  struct SetStore(T)
    include Atomically

    getter store

    delegate :each, to: @store
    delegate :empty?, to: @store
    delegate :includes?, to: @store
    delegate :inspect, to: @store
    delegate :size, to: @store

    def initialize
      @store = Set(T).new
      @atomic_lock = Mutex.new(:reentrant)
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
      atomically do
        store.add(object)
      end
    end

    def add?(object : T) : Bool
      atomically do
        store.add?(object)
      end
    end

    def assign(new_set : Set(T)) : self
      atomically do
        @store = new_set.clone
        self
      end
    end

    def concat(elems : SetStore(T)) : self
      atomically do
        store.concat(elems.store)
        self
      end
    end

    def delete(object : T) : Bool
      atomically do
        store.delete(object)
      end
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
      atomically do
        store.subtract(other.store)
      end

      self
    end

    def subtract(other : Enumerable) : self
      atomically do
        store.subtract(other)
      end

      self
    end

    def |(other : SetStore(T)) : SetStore(T)
      new_set = SetStore(T).new
      new_set.assign(store | other.store)
    end
  end
end
