module Atomically
  @atomic_lock = Mutex.new

  protected def atomically(lock : Mutex = @atomic_lock)
    lock.synchronize do
      yield
    end
  end
end
