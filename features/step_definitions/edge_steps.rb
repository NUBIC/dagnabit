Given /^the (edge \(.+\))$/ do |edge|
  edge.save
end

# A given should always fail fast, but we expect this when-step to fail sometimes (i.e.
# when deliberately introducing a cycle), and we don't want that failure to affect the
# scenario run.
When /^I insert the (edge \(.+\))$/ do |edge|
  begin
    edge.save
  rescue => e
  end
end

Then /^the (edge .+) should not exist$/ do |edge|
  Edge.exists?(:parent_id => edge.parent_id, :child_id => edge.child_id).should be_false
end

Then /^the (edge .+) should exist$/ do |edge|
  Edge.exists?(:parent_id => edge.parent_id, :child_id => edge.child_id).should be_true
end
