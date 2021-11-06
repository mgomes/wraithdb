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
    end
  end
end
