RSpec::Matchers.define(:be_set_equivalent_to) do |*expected|
  match do |actual|
    Set.new(actual).should == Set.new(expected)
  end
end
