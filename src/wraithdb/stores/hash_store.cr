require "../atomically"

module Wraith
  struct HashStore(K, V)
    include Atomically

    getter store

    delegate dup, to: @store

    def initialize
      @store = {} of K => HashEntry(V)
      @atomic_lock = Mutex.new(:reentrant)
    end

    # Returns the value of the key. If the key does not exist or has expired,
    # nil is returned.
    #
    # **Return value**: The value for the key.
    #
    # Example:
    #
    # ```
    # hash_store.set("a", 1)
    # hash_store.get("a") => 1
    # hash_store.get("b") => nil
    # ```
    def get(key : K)
      entry = store[key]?
      value = nil

      if entry && !entry.expired?
        value = entry.value
      end

      value
    end

    # An alias for #get
    # ```
    def [](key : K)
      get(key)
    end

    # Returns the value of the key along with the remaining TTL, in ms, as a
    # tuple. If the key does not have a TTL, the TTL portion of the tuple will
    # be nil. If the key does not exist or has expired, nil is returned.
    #
    # **Return value**: A tuple containing the value and expiration in ms.
    #
    # Example:
    #
    # ```
    # hash_store.set("a", 1, ttl: 10.milliseconds)
    # hash_store.set("b", 2)
    # hash_store.get_with_expiration("a") => {1, 10}
    # hash_store.get_with_expiration("b") => {2, nil}
    # hash_store.get_with_expiration("c") => nil
    # ```
    def get_with_expiration(key : K) : Tuple(V, Int64?)?
      entry = store[key]?

      if entry && entry.has_expiration? && !entry.expired?
        {entry.value, entry.expires_in_ms}
      elsif entry && !entry.has_expiration?
        {entry.value, nil}
      else
        nil
      end
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
      atomically do
        entry = HashEntry(V).new(val, ttl)
        store[key] = entry
        entry.value
      end
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
      atomically do
        set(key, val)
      end
    end

    # Deletes the key-value pair and returns the value, otherwise returns nil.
    def delete(key : K)
      atomically do
        entry = store.delete(key)
        entry ? entry.value : nil
      end
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
        atomically do
          entry.update_expiration(ttl)
          store[key] = entry
        end
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

    # Increments the value of a specified key. The class of the value needs
    # to either support `+` or have that method defined. If a magnitude is not
    # is not specified, it defaults to 1. If a key does not exist, the magnitude
    # will be set as the key's value and the key will not have an expiration.
    #
    # **Return value**: The incremented value.
    #
    # Examples:
    #
    # ```
    # hash_store.set("foo", 3) => 3
    # hash_store.inc("foo") => 4
    # hash_store.inc("foo", 3) => 7
    # hash_store.inc("foo", -2) => 5
    # hash_store.inc("bar") => 1
    # ```
    def inc(key : K, magnitude = 1) : V
      entry = store[key]?

      atomically do
        if entry && !entry.expired?
          entry.value += magnitude
          store[key] = entry
          entry.value
        else
          set(key, magnitude)
        end
      end
    end
  end
end
