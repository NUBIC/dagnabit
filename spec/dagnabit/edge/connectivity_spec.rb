require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Edge
  describe Connectivity do
    let(:vertex) { Class.new(Vertex) }
    let(:edge) { Edge[Vertex] }

    [:v1, :v2, :v3].each { |v| let(v) { vertex.new } }
    [:e1, :e2].each { |e| let(e) { edge.new } }

    before do
      edge.extend(Connectivity)

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
end
