require "msgpack"

module Wraith
  # Wraps Hash values. Each entry has a value and expiration.
  struct HashEntry(V)
    include MessagePack::Serializable

    @expires_at : Int64?

    getter value
    getter expires_at

    def initialize(@value : V, ttl : Time::Span?)
      update_expiration(ttl)
    end

    def update_expiration(ttl : Time::Span?)
      if ttl
        @expires_at = (Time.utc + ttl).to_unix_ms
      else
        @expires_at = nil
      end
    end

    def has_expiration?
      expires_at != nil
    end

    # Checks if the entry is expired.
    def expired?
      if expires_at
        expires_at.not_nil! <= Time.utc.to_unix_ms
      end
    end

    def expires_in_ms : Int64?
      if expires_at
        expires_at.not_nil! - Time.utc.to_unix_ms
      else
        nil
      end
    end
  end
end
