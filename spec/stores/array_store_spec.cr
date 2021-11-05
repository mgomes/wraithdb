require "../spec_helper"

describe Wraith do
  context Wraith::ArrayStore do
    describe "read method" do
      sample_array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
      array_store = Wraith::ArrayStore(Int32).new

      before_each do
        array_store.assign(sample_array)
      end

      describe "#[]" do
        it "should return the element at the specified index" do
          array_store[5].should eq 5
        end

        it "should wrap if a negative index is used" do
          array_store[-2].should eq 8
        end

        it "should raise an IndexError if no element exists at the index" do
          expect_raises(IndexError) do
            array_store[10]
          end
        end
      end

      describe "#all?" do
        it "should return true if all elements match criteria" do
          evens = Wraith::ArrayStore(Int32).new
          odds = Wraith::ArrayStore(Int32).new
          evens.assign([2, 4, 6, 8])
          odds.assign([1, 3, 5, 7])

          evens.all? { |elem| elem.even? }.should be_true
          odds.all? { |elem| elem.odd? }.should be_true
        end

        it "should return false if some elements do not match criteria" do
          mixed = Wraith::ArrayStore(Int32).new
          mixed.assign([1, 2, 3, 4])
          mixed.all? { |elem| elem.even? }.should be_false
        end
      end

      describe "#any?" do
        it "should return true if any elements match criteria" do
          mixed = Wraith::ArrayStore(Int32).new
          mixed.assign([1, 2, 3, 4])
          mixed.any? { |elem| elem.even? }.should be_true
        end

        it "should return false if no elements match criteria" do
          evens = Wraith::ArrayStore(Int32).new
          odds = Wraith::ArrayStore(Int32).new
          evens.assign([2, 4, 6, 8])
          odds.assign([1, 3, 5, 7])

          evens.any? { |elem| elem.odd? }.should be_false
          odds.any? { |elem| elem.even? }.should be_false
        end
      end

      describe "compact" do
        it "should return an array without nils" do
          array = Wraith::ArrayStore(Int32?).new
          array.assign([1, nil, 2, nil])
          array.compact.should eq [1, 2]
          array.should eq([1, nil, 2, nil])
        end

        it "should leave an array without nils alone" do
          array_store.compact.should eq sample_array
        end
      end

      describe "#count" do
        it "should return the number of specified elements in an array" do
          array_store.count(1).should eq 1
        end

        it "should return the number of elements that match criteria" do
          array_store.count { |elem| elem.even? }.should eq 5
        end
      end

      describe "#each" do
        it "should iterate through each element" do
          new_array = Array(Int32).new
          array_store.each do |elem|
            new_array << elem
          end

          new_array.should eq sample_array
        end
      end

      describe "#each_with_index" do
        it "should iterate through each element" do
          new_array = Array(Int32).new
          sum = 0
          array_store.each_with_index do |elem, i|
            new_array << elem
            sum += i
          end

          new_array.should eq sample_array
          sum.should eq 45
        end
      end

      describe "#first" do
        it "should return the first element" do
          array_store.first.should eq 0
        end
      end

      describe "#index" do
        it "returns the index of the element" do
          array_store.index(5).should eq 5

          array = Wraith::ArrayStore(String).new
          array.assign(["a", "b", "c"])
          array.index("b").should eq 1
        end
      end

      describe "#join" do
        it "returns a string joined by the specified separator" do
          array_store.join("/").should eq "0/1/2/3/4/5/6/7/8/9"
        end

        it "should do nothing with a blank array" do
          array_store.assign([] of Int32)
          array_store.join("%").should eq ""
        end
      end

      describe "#last" do
        it "should return the first element" do
          array_store.last.should eq 9
        end
      end

      describe "#map" do
        it "should iterate through each element and run the block" do
          new_array = Array(Int32).new
          new_array = array_store.map { |elem| elem * 2 }

          new_array.should eq [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]
          array_store.should eq sample_array
        end
      end

      describe "#max" do
        it "should return the element with the max value" do
          array_store.max.should eq 9
        end
      end

      describe "#min" do
        it "should return the element with the min value" do
          array_store.min.should eq 0
        end
      end

      describe "#minmax" do
        it "should return a tuple with the min and max elements" do
          array_store.minmax.should eq({0, 9})
        end
      end

      describe "#reject" do
        it "should return a new array excluding elements matching criteria" do
          new_array = Array(Int32).new
          new_array = array_store.reject { |elem| elem.even? }

          new_array.should eq [1, 3, 5, 7, 9]
          array_store.should eq sample_array
        end
      end

      describe "#reverse" do
        it "should return a new array in reverse order" do
          array_store.reverse.should eq [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
          array_store.should eq sample_array
        end
      end

      describe "#sample" do
        it "should return a random element from the array" do
          sample = array_store.sample
          sample.should be >= 0
          sample.should be <= 9
        end
      end

      describe "#select" do
        it "should return a new array excluding elements not matching criteria" do
          new_array = Array(Int32).new
          new_array = array_store.select { |elem| elem.even? }

          new_array.should eq [0, 2, 4, 6, 8]
          array_store.should eq sample_array
        end
      end

      describe "#shuffle" do
        array_store.assign([1, 2, 3])
        b = array_store.shuffle
        while (array_store == b)
          b = array_store.shuffle
        end
        array_store.should eq([1, 2, 3])

        3.times { b.includes?(array_store.shift).should be_true }
      end

      describe "#size" do
        it "should return the number of elements in an array" do
          array_store.size.should eq 10
        end
      end

      describe "#sum" do
        it "should return the sum of all the elements" do
          array_store.sum.should eq 45
        end
      end

      describe "#uniq" do
        it "should return an array with all duplicate elements removed" do
          dupe_values = [1, 2, 3, 1, 2, 3, 3, 3, 1, 1]
          array_store.assign(dupe_values)
          array_store.uniq.should eq([1, 2, 3])
          array_store.should eq dupe_values
        end
      end
    end
  end
end
