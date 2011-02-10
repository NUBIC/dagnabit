##
# Returns true if two finite sets are equivalent, false otherwise.
#
# This matcher expects its operands to respond to #to_a, which in turn should
# return something enumerable.
RSpec::Matchers.define(:be_set_equivalent_to) do |*expected|
  match do |actual|
    Set.new(actual.to_a).should == Set.new(expected.to_a)
  end
end
