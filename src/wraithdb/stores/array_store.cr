require "../atomically"

module Wraith
  struct ArrayStore(T)
    include Atomically

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
      @atomic_lock = Mutex.new(:reentrant)
    end

    def <<(elem : T) : self
      atomically do
        store << elem
      end

      self
    end

    def []=(index : Int, value : T)
      atomically do
        store[index] = value
      end
    end

    def []=(range : Range, value : T)
      atomically do
        store[range] = value
      end
    end

    def ==(other_array) : Bool
      store == other_array
    end

    def assign(new_array : Array(T))
      @store = new_array
    end

    def compact! : self
      atomically do
        store.compact!
      end

      self
    end

    def delete(obj) : T?
      atomically do
        store.delete(obj)
      end
    end

    def delete_at(index : Int) : self
      atomically do
        store.delete_at(index)
      end

      self
    end

    def pop : T
      atomically do
        store.pop
      end
    end

    # Append. Pushes one value to the end of `self`, given that the type of the value is *T*
    # (which might be a single type or a union of types).
    # This method returns `self`, so several calls can be chained.
    # See `pop` for the opposite effect.
    #
    # ```
    # a = ["a", "b"]
    # a.push("c") # => ["a", "b", "c"]
    # a.push(1)   # Errors, because the array only accepts String.
    #
    # a = ["a", "b"] of (Int32 | String)
    # a.push("c") # => ["a", "b", "c"]
    # a.push(1)   # => ["a", "b", "c", 1]
    # ```
    def push(value : T)
      atomically do
        store.push(value)
      end

      self
    end

    # Append multiple values. The same as `push`, but takes an arbitrary number
    # of values to push into `self`. Returns `self`.
    #
    # ```
    # a = ["a"]
    # a.push("b", "c") # => ["a", "b", "c"]
    # ```
    def push(*values : T) : self
      atomically do
        store.push(values)
      end

      self
    end

    # Modifies `self`, deleting the elements in the collection for which the
    # passed block returns `true`. Returns `self`.
    #
    # ```
    # ary = [1, 6, 2, 4, 8]
    # ary.reject! { |x| x > 3 }
    # ary # => [1, 2]
    # ```
    def reject!(& : T ->) : self
      atomically do
        store.reject! { |e| yield e }
      end

      self
    end

    # Modifies `self`, deleting the elements in the collection for which
    # `pattern === element`.
    #
    # ```
    # ary = [1, 6, 2, 4, 8]
    # ary.reject!(3..7)
    # ary # => [1, 2, 8]
    # ```
    def reject!(pattern) : self
      atomically do
        store.reject! { |elem| pattern === elem }
      end

      self
    end

    def reverse! : self
      atomically do
        store.reverse!
      end

      self
    end

    def shift : T
      atomically do
        store.shift
      end
    end

    def uniq! : self
      atomically do
        store.uniq!
      end

      self
    end
  end
end
