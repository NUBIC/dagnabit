require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Vertex
  describe Settings do
    let(:model) { Class.new(Vertex) }
    let(:edge) { Edge[Vertex] }

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

    describe '#set_edge_model' do
      it 'sets the edge model' do
        model.set_edge_model edge

        model.edge_model.should == edge
      end

      it 'sets the edge table name' do
        model.set_edge_table ''
        model.set_edge_model edge

        model.edge_table.should == edge.table_name
      end

      it 'does not set the edge table name if model is nil' do
        model.set_edge_table 'my_edges'
        model.set_edge_model nil

        model.edge_table.should == 'my_edges'
      end
    end

    describe '#inherited' do
      it "copies the superclass' edge table to the subclass" do
        model.set_edge_table 'my_edges'

        subclass = Class.new(model)

        subclass.edge_table.should == model.edge_table
      end

      it "copies the superclass' edge model to the subclass" do
        model.set_edge_model edge

        subclass = Class.new(model)

        subclass.edge_model.should == model.edge_model
      end
    end
  end
end
