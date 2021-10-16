require "msgpack"

module Wraith
  # Wraps Hash values. Each entry has a value and expiration.
  struct HashEntry(V)
    include MessagePack::Serializable

    @expires_at : Int64?

    getter value
    getter expires_at

    def initialize(@value : V, expires_in : Time::Span?)
      update_expiration(expires_in)
    end

    def update_expiration(expires_in : Time::Span?)
      if expires_in
        @expires_at = (Time.utc + expires_in).to_unix_ms
      else
        @expires_at = nil
      end
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
