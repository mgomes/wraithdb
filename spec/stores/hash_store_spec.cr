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

    describe "#delete" do
      hash_store = Wraith::HashStore(String, Int32).new

      it "should delete a key" do
        hash_store.set("a", 1)
        hash_store.set("b", 2)
        hash_store.delete("a")
        hash_store["a"].should be_nil
      end

      it "should return the deleted key" do
        hash_store.set("a", 32)
        hash_store.delete("a").should eq 32
      end

      it "should return the nil if the key does not exist" do
        hash_store.set("a", 32)
        hash_store.delete("z").should be_nil
      end
    end

    describe "#keys" do
      hash_store = Wraith::HashStore(String, Int32).new

      it "should return an array of all the keys" do
        hash_store.set("a", 1)
        hash_store.set("b", 2)
        hash_store.keys.should eq ["a", "b"]
      end

      it "should return an empty array if there are no keys" do
        hash_store = Wraith::HashStore(String, Int32).new
        hash_store.keys.should be_empty
      end
    end

    describe "#values" do
      hash_store = Wraith::HashStore(String, Int32).new

      it "should return an array of all the values" do
        hash_store.set("a", 1)
        hash_store.set("b", 2)
        hash_store.set("c", 3)

        hash_store.values.should eq [1, 2, 3]
      end

      it "should return an empty array if there are no keys" do
        hash_store = Wraith::HashStore(String, Int32).new
        hash_store.values.should be_empty
      end
    end
  end
end
