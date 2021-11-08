require "../spec_helper"

describe Wraith do
  context Wraith::SetStore do
    describe "read method" do
      sample_set1 = Set{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
      sample_set2 = Set{5, 6, 7, 8, 9}
      set_store1 = Wraith::SetStore(Int32).new
      set_store2 = Wraith::SetStore(Int32).new

      before_each do
        set_store1.assign(sample_set1)
        set_store2.assign(sample_set2)
      end

      describe "#==" do
        it "should return a true if both set_stores are equal" do
          set_store3 = Wraith::SetStore(Int32).new
          set_store3.assign(sample_set2)
          (set_store2 == set_store3).should be_true
        end

        it "should return a false if both set_stores are NOT equal" do
          set_store3 = Wraith::SetStore(Int32).new
          set_store3.assign(sample_set2)
          (set_store2 == set_store1).should be_false
        end
      end

      describe "#&" do
        it "should return a new SetStore containing the intersection of the two sets" do
          intersection = set_store1 & set_store2
          intersection.should eq set_store2
        end
      end

      describe "#+" do
        it "should return a new SetStore containing the unique elements from both sets" do
          set = set_store1 + set_store2
          set.should eq set_store1
        end
      end

      describe "#^" do
        it "should return a new SetStore containing the symmetric difference between the sets" do
          set_a = Wraith::SetStore(Char).new
          set_b = Wraith::SetStore(Char).new
          set_a.assign(Set{'a', 'b', 'b', 'z'})
          set_b.assign(Set{'a', 'b', 'c'})

          symmetric_diff = set_a ^ set_b
          expected_set = Wraith::SetStore(Char).new
          expected_set.assign(Set{'z', 'c'})
          symmetric_diff.should eq expected_set
        end
      end

      describe "#empty?" do
        it "should return true if the set is empty" do
          set_store1.empty?.should be_false
          set_store2.assign(Set(Int32).new)
          set_store2.empty?.should be_true
        end
      end

      describe "#includes?" do
        it "should return true if the set contains the element" do
          set_store1.includes?(5).should be_true
        end

        it "should return false if the set does not contain the element" do
          set_store1.includes?(10).should be_false
        end
      end

      describe "#inspect" do
        it "should return a string representation of the set" do
          set_store1.inspect.should eq "Set{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}"
        end
      end

      describe "#intersects?" do
        it "should return true if the set intersects with the other set" do
          set_store1.intersects?(set_store2).should be_true
        end

        it "should return false if the set does not intersect with the other set" do
          sample_set3 = Set{10, 11, 12, 13, 14}
          set_store3 = Wraith::SetStore(Int32).new
          set_store3.assign(sample_set3)
          set_store1.intersects?(set_store3).should be_false
        end
      end

      describe "#proper_subset_of?" do
        it "should return true if the set is a proper subset of the other set" do
          set_store2.proper_subset_of?(set_store1).should be_true
          # The inverse of a proper subset is a proper superset
          set_store1.proper_subset_of?(set_store2).should be_false
        end
      end

      describe "#proper_superset_of?" do
        it "should return true if the set is a proper subset of the other set" do
          set_store1.proper_superset_of?(set_store2).should be_true
          # The inverse of a proper superset is a proper subset
          set_store2.proper_superset_of?(set_store1).should be_false
        end
      end

      describe "#size" do
        it "should return the size of the set" do
          set_store1.size.should eq 10
        end
      end

      describe "#subset_of?" do
        it "should return true if the set is a proper subset of the other set" do
          set_store2.subset_of?(set_store1).should be_true
          # The inverse of a subset is a superset
          set_store1.subset_of?(set_store2).should be_false
        end
      end

      describe "#|" do
        it "should return a new SetStore containing the unique elements of both sets" do
          set_a = Wraith::SetStore(Int32).new
          set_b = Wraith::SetStore(Int32).new
          union_set = Wraith::SetStore(Int32).new
          set_a.assign(Set{0, 1, 2, 3})
          set_b.assign(Set{0, 0, 1, 2, 2, 3, 5})
          union_set.assign(Set{0, 1, 2, 3, 5})

          (set_a | set_b).should eq union_set
        end
      end
    end

    describe "write method" do
      sample_set = Set{0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
      set_store = Wraith::SetStore(Int32).new

      before_each do
        set_store.assign(sample_set)
      end

      describe "#add" do
        it "should add the element to the set" do
          set_store.add(10)

        end
      end
    end
  end
end
