require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Vertex
  describe Bonding do
    let(:vertex) { Class.new(Vertex) }
    let(:edge) { Edge[Vertex] }
    let(:v) { vertex.new }
    let(:g) { Dagnabit::Graph.new }

    before do
      vertex.extend(Settings)
      vertex.send(:include, Bonding)
    end

    describe '#bond_for' do
      before do
        vertex.set_edge_model edge
      end

      it 'raises if an edge vertex has not been set' do
        vertex.set_edge_model(nil)

        lambda { v.bond_for(g) }.should raise_error(RuntimeError)
      end

      it 'connects a vertex to the source vertices of a graph' do
        v1 = vertex.new
        v2 = vertex.new

        [v1, v2].each { |v| v.save }
        g.vertices = [v1, v2]

        edges = v.bond_for(g)

        edges.should contain_edges([v, v1], [v, v2])
      end
    end
  end
end
