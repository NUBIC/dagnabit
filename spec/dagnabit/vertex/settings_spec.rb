require 'spec_helper'

require 'models/vertex'

module Dagnabit::Vertex
  describe Settings do
    let(:model) { Class.new(Vertex) }

    before do
      model.extend(Settings)
    end

    describe '#edge_table' do
      it 'defaults to "edges"' do
        model.edge_table.should == 'edges'
      end
    end

    describe '#set_edge_table' do
      it 'sets the name of the edge table' do
        model.set_edge_table 'other_edges'

        model.edge_table.should == 'other_edges'
      end
    end
  end
end
