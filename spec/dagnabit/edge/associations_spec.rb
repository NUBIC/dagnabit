require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Edge
  describe Associations do
    let(:edge) { Class.new(Edge) }
    let(:e) { edge.new }
    let(:v) { Vertex.new }

    before do
      edge.extend(Associations)

      edge.edge_for(v.class.name)
    end

    describe '#parent' do
      it 'points to the parent vertex' do
        e.parent = v
        e.save

        edge.find(e).parent.should == v
      end
    end

    describe '#child' do
      it 'points to the child vertex' do
        e.child = v
        e.save

        edge.find(e).child.should == v
      end
    end
  end
end
