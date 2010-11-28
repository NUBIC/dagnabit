require 'spec_helper'

require 'models/edge'
require 'models/other_edge'
require 'models/other_vertex'
require 'models/vertex'

module Dagnabit::Vertex
  describe Connectivity do
    shared_examples_for Connectivity do
      [:v1, :v2, :v3].each { |v| let(v) { model.new } }

      before do
        edge.create(:parent => v1, :child => v2)
        edge.create(:parent => v2, :child => v3)
      end

      describe '.inherited' do
        let(:subclass) { Class.new(model) }

        it 'extends subclasses with itself' do
          Connectivity.instance_methods.each do |m|
            subclass.should respond_to(m)
          end
        end
      end

      describe '#roots_of' do
        it 'returns the source vertices of a vertex' do
          model.roots_of(v3).should == [v1]
        end

        it 'returns the source vertices of a set of vertices' do
          v4 = model.new

          edge.create(:parent => v2, :child => v4)

          model.roots_of(v3, v4).should == [v1]
        end

        it 'returns an empty list for source vertices' do
          model.roots_of(v1).should be_empty
        end
      end

      describe '#ancestors_of' do
        it 'returns the ancestors of a vertex' do
          model.ancestors_of(v3).should be_set_equivalent_to(v1, v2)
        end

        it 'returns the ancestors of a set of vertices' do
          v4 = model.new

          edge.create(:parent => v3, :child => v4)

          model.ancestors_of(v2, v4).length.should == 3
          model.ancestors_of(v2, v4).should be_set_equivalent_to(v1, v2, v3)
        end

        it 'returns an empty list for vertices with no ancestors' do
          model.ancestors_of(v1).should be_empty
        end
      end

      describe '#parents_of' do
        it 'returns the immediate parents of a vertex' do
          model.parents_of(v3).should be_set_equivalent_to(v2)
        end

        it 'returns the immediate parents of a set of vertices' do
          v4 = model.new

          edge.create(:parent => v2, :child => v4)

          model.parents_of(v3, v4).should == [v2]
        end

        it 'returns an empty list for vertices with no parents' do
          model.parents_of(v1).should be_empty
        end
      end

      describe '#children_of' do
        it 'returns the immediate children of a vertex' do
          model.children_of(v1).should be_set_equivalent_to(v2)
        end

        it 'returns the immediate children of a set of vertices' do
          edge.delete_all

          edge.create(:parent => v1, :child => v2)
          edge.create(:parent => v3, :child => v2)

          model.children_of(v1, v3).should == [v2]
        end

        it 'returns an empty list for vertices with no children' do
          model.children_of(v3).should be_empty
        end
      end

      describe '#descendants_of' do
        it 'returns the descendants of a vertex' do
          model.descendants_of(v1).should be_set_equivalent_to(v2, v3)
        end

        it 'returns the descendants of a set of vertices' do
          v4 = model.new
          v5 = model.new

          edge.create(:parent => v4, :child => v5)

          model.descendants_of(v1, v4).length.should == 3
          model.descendants_of(v1, v4).should be_set_equivalent_to(v2, v3, v5)
        end

        it 'returns an empty list for vertices with no descendants' do
          model.descendants_of(v3).should be_empty
        end
      end
    end

    describe 'with default model names' do
      let(:model) { Class.new(Vertex) }
      let(:edge) { Edge[Vertex] }

      before do
        model.extend(Connectivity)
      end

      it_behaves_like Connectivity
    end

    describe 'with custom model names' do
      let(:model) { Class.new(OtherVertex) }
      let(:edge) { OtherEdge[OtherVertex] }

      before do
        model.extend(Connectivity)

        model.set_edge_table 'other_edges'
      end

      it_behaves_like Connectivity
    end

    describe 'with subclasses using custom model names' do
      let(:base) { Class.new(OtherVertex) }
      let(:model) { Class.new(base) }
      let(:edge) { OtherEdge[OtherVertex] }

      before do
        base.extend(Connectivity)

        base.set_edge_table 'other_edges'
      end

      it_behaves_like Connectivity
    end
  end
end
