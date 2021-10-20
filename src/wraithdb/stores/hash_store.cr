module Wraith
  struct HashStore(K, V)
    getter store

    delegate dup, to: @store

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

    # Sets the value for the key. Accepts a (time-to-live) `ttl` Time::Span
    # value. Keys that have exceeded their TTL will be purged.
    #
    # **Return value**: The value of the key.
    #
    # Example:
    #
    # ```
    # hash_store.set("key", 1)
    # hash_store.set(key: "key", val: 1)
    # hash_store.set("key", 1, ttl: 500.milliseconds)
    # hash_store.set(key: "key", val: 1, ttl: 2.days)
    # ```
    def set(key : K, val : V, ttl = nil)
      store[key] = HashEntry(V).new(val, ttl)
    end

    # Sets the value for the key. Keys set with the `[]=` syntax do not support
    # an expiration.
    #
    # **Return value**: The value of the key.
    #
    # Example:
    #
    # ```
    # hash_store["k"] = 1
    # ```
    def []=(key : K, val : V)
      set(key, val)
    end

    # Deletes the key-value pair and returns the value, otherwise returns nil.
    def delete(key : K)
      entry = store.delete(key)
      entry ? entry.value : nil
    end

    # Returns the remaining time to live of a key. If a `ttl` is set
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
    def ttl(key : K, ttl = nil) : Int64?
      entry = store[key]?

      if entry && ttl
        entry.update_expiration(ttl)
        store[key] = entry
        entry.expires_in_ms
      elsif entry
        entry.expires_in_ms
      else
        nil
      end
    end

    # Returns an array of all keys in a hash.
    # If a key is expired, it will not be returned.
    def keys : Array(K)
      _keys = [] of K

      store.each do |k, entry|
        _keys << k unless entry.expired?
      end

      _keys
    end

    # Returns an array of all values in a hash.
    # If a key is expired, its value will not be returned.
    def values : Array(V)
      _values = [] of V

      store.each do |k, entry|
        _values << entry.value unless entry.expired?
      end

      _values
    end
  end
end
