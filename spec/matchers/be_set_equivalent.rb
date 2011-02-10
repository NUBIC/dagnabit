RSpec::Matchers.define(:be_set_equivalent_to) do |*expected|
  match do |actual|
    Set.new(actual.to_a).should == Set.new(expected.to_a)
  end
end
