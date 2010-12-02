require 'spec_helper'

require 'models/edge'
require 'models/other_edge'
require 'models/vertex'

module Dagnabit::Vertex
  describe Settings do
    let(:model) { Class.new(Vertex) }

    shared_examples_for 'a method that sets edge information' do |expected_model|
      it 'sets the edge model' do
        model.edge_model.should == expected_model
      end

      it 'sets the edge table from the edge model' do
        model.edge_table.should == expected_model.table_name
      end
    end

    describe '#connected_by' do
      describe 'with default settings' do
        it_behaves_like 'a method that sets edge information', Edge
      end

      describe 'with custom settings' do
        before do
          model.connected_by 'OtherEdge'
        end

        it_behaves_like 'a method that sets edge information', OtherEdge
      end
    end

    describe '#inherited' do
      it "copies the superclass' edge model to the subclass" do
        subclass = Class.new(model)

        subclass.edge_model.should == model.edge_model
      end

      it "copies the superclass' edge table to the subclass" do
        subclass = Class.new(model)

        subclass.edge_table.should == model.edge_table
      end
    end
  end
end
