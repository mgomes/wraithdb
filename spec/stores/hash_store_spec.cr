require "../spec_helper"

describe Wraith do
  context Wraith::HashStore do
    describe "setting, getting, and expirations" do
      hash_store = Wraith::HashStore(String, String).new

      before_each do
        hash_store = Wraith::HashStore(String, String).new
      end

      describe "#set and #get" do
        it "should return the same values that were set" do
          hash_store.set("foo", "a")
          hash_store.set("bar", "b")
          hash_store.get("foo").should eq "a"
          hash_store.get("bar").should eq "b"
        end

        it "should return nil if the key was not found" do
          hash_store.get("some_key").should be_nil
        end
      end

      describe "#[] and #[]=" do
        it "should return the same values that were set" do
          hash_store["foo"] = "a"
          hash_store["bar"] = "b"
          hash_store["foo"].should eq "a"
          hash_store["bar"].should eq "b"
        end

        it "should return nil if the key was not found" do
          hash_store["some_key"].should be_nil
        end
      end

      describe "values with expirations" do

      end
    end

    describe "#keys" do
      hash_store = Wraith::HashStore(String, Int32).new

      it "should return an array of all the keys" do
        hash_store.set("a", 1)
        hash_store.set("b", 2)
        hash_store.keys.should eq ["a", "b"]
      end
    end
  end
end
