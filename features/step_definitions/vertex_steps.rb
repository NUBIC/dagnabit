Given /^the vertices$/ do |table|
  table.hashes.each do |hash|
    Vertex.create(:datum => hash['datum'])
  end
end
