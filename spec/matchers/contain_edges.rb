RSpec::Matchers.define(:contain_edges) do |*expected|
  match do |actual|
    @failure_reason = :is_nil
    @failure_data = nil
    actual.should_not be_nil

    @failure_reason = :length_mismatch
    @failure_data = expected.length
    actual.length.should == expected.length

    @failure_reason = :missing_edge
    expected.each do |parent, child|
      unless actual.any? { |e| e.parent == parent && e.child == child }
        @failure_data = "(#{parent}, #{child})"
        raise
      end
    end
  end

  failure_message_for_should do |actual|
    case @failure_reason
    when :is_nil then "Edge set should not be nil"
    when :length_mismatch then "Expected #{@failure_data} edges, got #{actual.length}"
    when :missing_edge then "Expected edge #{@failure_data} to be present"
    end
  end
end
