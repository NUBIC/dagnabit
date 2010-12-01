require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit::Edge
  describe Associations do
    let(:c) { Vertex.new }
    let(:p) { Vertex.new }

    let(:e) { Edge.create(:parent => p, :child => c) }

    describe '#parent' do
      it 'retrieves the parent vertex' do
        Edge.find(e).parent.should == p
      end
    end

    describe '#child' do
      it 'retrieves the child vertex' do
        Edge.find(e).child.should == c
      end
    end
  end
end
