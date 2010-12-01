require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Vertex
  describe Bonding do
    let(:g) { Dagnabit::Graph.new }
    let!(:v) { Vertex.create }

    describe '#bond_for' do
      [:v1, :v2].each { |v| let!(v) { Vertex.create } }

      before do
        Vertex.set_edge_model(Edge)
      end

      it 'raises if an edge vertex has not been set' do
        Vertex.set_edge_model(nil)

        lambda { v.bond_for(g) }.should raise_error(RuntimeError)
      end

      it 'raises if the vertex has not been saved' do
        v = Vertex.new

        lambda { v.bond_for(g) }.should raise_error(RuntimeError)
      end

      it 'connects a vertex to the source vertices of a graph' do
        g.vertices = [v1, v2]

        edges = v.bond_for(g)

        edges.should contain_edges([v, v1], [v, v2])
      end

      it 'does not build edges that already exist' do
        g.vertices = [v1, v2]
        g.edges = [Edge.create(:parent => v, :child => v1)]

        edges = v.bond_for(g)

        edges.should contain_edges([v, v2])
      end

      it 'builds edges that can be saved' do
        Vertex.extend(Connectivity)
        g.vertices = [v1, v2]

        edges = v.bond_for(g)
        edges.all? { |e| e.save }.should be_true

        Vertex.children_of(v).should be_set_equivalent_to(v1, v2)
      end

      it 'does not build edges that were created from a previous bonding' do
        g.vertices = [v1, v2]

        edges = v.bond_for(g)
        edges.each { |e| e.save }

        v.bond_for(g).should be_empty
      end
    end
  end
end
