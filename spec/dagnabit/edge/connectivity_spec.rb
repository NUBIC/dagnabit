require 'spec_helper'

require 'models/edge'
require 'models/other_edge'
require 'models/other_vertex'
require 'models/vertex'

module Dagnabit::Edge
  describe Connectivity do
    shared_examples_for Connectivity do
      [:v1, :v2, :v3].each { |v| let(v) { vertex.new } }
      [:e1, :e2].each { |e| let(e) { edge.new } }

      before do
        e1.update_attributes(:parent => v1, :child => v2)
        e2.update_attributes(:parent => v2, :child => v3)

        [e1, e2].each(&:save)
      end

      describe '#connecting' do
        it 'returns the edges connecting the given vertices' do
          edge.connecting(v1, v2, v3).length.should == 2
          edge.connecting(v1, v2, v3).should be_set_equivalent_to(e1, e2)
        end
      end
    end

    describe 'with default model names' do
      let(:vertex) { Class.new(Vertex) }
      let(:edge) { Edge[Vertex] }

      before do
        edge.extend(Connectivity)
      end

      it_behaves_like Connectivity
    end

    describe 'with custom model names' do
      let(:vertex) { Class.new(OtherVertex) }
      let(:edge) { OtherEdge[OtherVertex] }

      before do
        edge.extend(Connectivity)
      end

      it_behaves_like Connectivity
    end
  end
end
