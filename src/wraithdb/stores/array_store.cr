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

    def <<(elem : T) : self
      store << elem
      self
    end

    def []=(index : Int, value : T)
      store[index] = value
    end

    def []=(range : Range, value : T)
      store[range] = value
    end

    def ==(other_array) : Bool
      store == other_array
    end

    def assign(new_array : Array(T))
      @store = new_array
    end

    def compact! : self
      store.compact!
      self
    end

    def delete(obj) : T?
      store.delete(obj)
    end

    def delete_at(index : Int) : self
      store.delete_at(index)
      self
    end

    def pop : T
      store.pop
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
      store.push(value)
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
      store.push(values)
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
      store.reject! { |e| yield e }
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
      store.reject! { |elem| pattern === elem }
      self
    end

    def reverse! : self
      store.reverse!
      self
    end

    def shift : T
      store.shift
    end

    def uniq! : self
      store.uniq!
      self
    end
  end
end
