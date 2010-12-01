Transform /^edge \((\d+), (\d+)\)$/ do |d1, d2|
  v1 = Vertex.find_or_create_by_datum(d1)
  v2 = Vertex.find_or_create_by_datum(d2)

  Edge.new(:parent => v1, :child => v2)
end
