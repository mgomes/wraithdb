require "./stores/*"

module Wraith
  class DB
    property ensemble
    getter db_path : String

    # alias StoreTypes = HashStore | ArrayStore | SetStore

    def initialize(@db_path : String)
      @ensemble = Hash(String, HashStore | ArrayStore | SetStore)
    end

    def init_or_load
      File.exists?(db_path) ? load : init
    end

    def init
      # noop
    end

    def load
      io = open_db(mode: "r")
      ensemble = Hash(String, HashStore | ArrayStore | SetStore).from_msgpack(io)
    end

    def [](store_name : String)
      ensemble[store_name]
    end

    def []=(store_name : String, store : HashStore | ArrayStore | SetStore)
      ensemble[store_name] = store
    end

    def persist
      io = open_db(mode: "w+")
      ensemble.to_msgpack(io)
    end

    # mode should be "r" for reading the DB and "w+" for writing to the DB
    private def open_db(mode = "r")
      File.open(db_path, mode)
    end
  end
end
