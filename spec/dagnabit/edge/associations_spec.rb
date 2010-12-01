require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Edge
  describe Associations do
    let(:e) { Edge.new }
    let(:v) { Vertex.new }

    describe '#parent' do
      it 'points to the parent vertex' do
        e.parent = v
        e.save

        Edge.find(e).parent.should == v
      end
    end

    describe '#child' do
      it 'points to the child vertex' do
        e.child = v
        e.save

        Edge.find(e).child.should == v
      end
    end
  end
end
