require 'spec_helper'

require 'models/vertex'

module Dagnabit::Vertex
  describe Bonding do
    let(:model) { Class.new(Vertex) }
    let(:v) { model.new }
    let(:g) { Dagnabit::Graph.new }

    before do
      model.extend(Settings)
      model.send(:include, Bonding)
    end

    describe '#bond_for' do
      it 'raises if an edge model has not been set' do
        model.set_edge_model(nil)

        lambda { v.bond_for(g) }.should raise_error(RuntimeError)
      end

      it 'connects a vertex to the source nodes of a graph'
    end
  end
end
