require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Vertex
  describe Associations do
    [:v1, :v2].each { |v| let(v) { ::Vertex.create } }

    shared_context 'edge' do
      let!(:e) { ::Edge.create(:parent_id => v1.id, :child_id => v2.id) }
    end

    describe '#in_edges' do
      include_context 'edge'

      it 'returns the edges whose tail is the receiver vertex' do
        v2.in_edges.should == [e]
      end

      it 'destroys all of its edges when the vertex is destroyed' do
        v2.destroy

        Edge.count.should == 0
      end
    end

    describe '#out_edges' do
      include_context 'edge'

      it 'returns the edges whose head is the receiver vertex' do
        v1.out_edges.should == [e]
      end

      it 'destroys all of its edges when the vertex is destroyed' do
        v1.destroy

        Edge.count.should == 0
      end
    end

    describe '#parents' do
      it 'accepts new vertices' do
        v1.parents << v2

        Vertex.find(v1).parents.should == [v2]
      end
    end

    describe '#children' do
      it 'accepts new vertices' do
        v1.children << v2

        Vertex.find(v1).children.should == [v2]
      end
    end
  end
end
