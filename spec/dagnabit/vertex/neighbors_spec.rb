require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Vertex
  describe Neighbors do
    let(:model) { Class.new(Vertex) }
    let(:edge) { Edge }

    [:v1, :v2, :v3].each { |v| let(v) { model.create } }

    before do
      model.extend(Connectivity)
      model.send(:include, Neighbors)

      edge.create(:parent_id => v1.id, :child_id => v2.id)
      edge.create(:parent_id => v2.id, :child_id => v3.id)
    end

    describe '#roots' do
      it 'returns the source vertices of the receiver vertex' do
        v3.roots.should == [v1]
      end
    end

    describe '#ancestors' do
      it 'returns the ancestors of the receiver vertex' do
        v3.ancestors.should be_set_equivalent_to(v1, v2)
      end
    end

    describe '#parents' do
      it 'returns the parents of the receiver vertex' do
        v3.parents.should == [v2]
      end
    end

    describe '#children' do
      it 'returns the children of the receiver vertex' do
        v1.children.should == [v2]
      end
    end

    describe '#descendants' do
      it 'returns the descendants of the receiver vertex' do
        v1.descendants.should be_set_equivalent_to(v2, v3)
      end
    end
  end
end
