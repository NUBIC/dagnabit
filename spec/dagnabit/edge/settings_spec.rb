require 'spec_helper'

require 'models/edge'

module Dagnabit::Edge
  describe Settings do
    let(:model) { Edge[ActiveRecord::Base] }

    before do
      model.extend(Settings)
    end

    describe '#vertex_table' do
      it 'defaults to "vertices"' do
        model.vertex_table.should == 'vertices'
      end
    end

    describe '#set_vertex_table' do
      it 'sets the name of the vertex table' do
        model.set_vertex_table 'other_vertices'

        model.vertex_table.should == 'other_vertices'
      end
    end
  end
end
