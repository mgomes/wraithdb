module Wraith
  struct HashStore(K, V)
    getter store

    def initialize
      @store = {} of K => HashEntry(V)
    end

    def get(key : K)
      entry = store[key]?
      value = nil

      if entry && !entry.expired?
        value = entry.value
      end

      value
    end

    def [](key : K)
      get(key)
    end

    def get_with_expiration(key : K) : Tuple(K, Int64)?
      entry = store[key]?
      value = nil

      if entry && !entry.expired?
        value = entry.value
      end

      value.nil? ? nil : {value, entry.expires_at}
    end

    def set(key : K, val : V, expires_in = nil)
      store[key] = HashEntry(V).new(val, expires_in)
    end

    # Sets the value for the key. Keys set with the `[]=` syntax do not support
    # an expiration.
    #
    # **Return value**: Integer: The value of the key.
    #
    # Example:
    #
    # ```
    # hash_store["k"] = 1
    # ```
    def []=(key : K, val : V)
      set(key, val)
    end

    def del(key : K)
      store.delete(key)
    end

    # Returns the remaining time to live of a key. If an `expires_in` is set
    # it will update the TTL for the key to the specified value.
    #
    # **Return value**: Integer: TTL in seconds, or Nil to indicate the key
    # does not exist.
    #
    # Examples:
    #
    # ```
    # hash_store.ttl("foo", 3) => 3
    # hash_store.ttl("bar", 0) => 0
    # hash_store.ttl("bar") # => nil
    # ```
    def ttl(key : K, expires_in = nil) : Int64?
      entry = store[key]?

      if entry
        entry.update_expiration(expires_in)
        entry.expires_in_ms
      else
        nil
      end
    end

    def keys
      store.keys
    end
  end
end
