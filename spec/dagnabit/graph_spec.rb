require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit
  describe Graph do
    let(:graph) { Graph.new }
    let(:vertex) { Class.new(::Vertex) }
    let(:edge)   { ::Edge[::Vertex] }

    describe '.from_vertices' do
      before do
        vertex.extend(Vertex::Connectivity)
        edge.extend(Edge::Connectivity)
      end

      it 'returns a graph' do
        Graph.from_vertices([], vertex, edge).should be_is_a(Graph)
      end

      describe 'graph' do
        describe 'given an empty vertex list' do
          let(:graph) { Graph.from_vertices([], vertex, edge) }

          it 'contains no vertices' do
            graph.vertices.should be_empty
          end

          it 'contains no edges' do
            graph.edges.should be_empty
          end
        end

        describe 'given a non-empty vertex list' do
          [:v1, :v2, :v3].each { |v| let(v) { vertex.new } }

          before do
            @e1 = edge.create(:parent => v1, :child => v2)
            @e2 = edge.create(:parent => v2, :child => v3)
            @graph = Graph.from_vertices([v1], vertex, edge)
          end

          it 'contains the given vertices' do
            @graph.vertices.should include(v1)
          end

          it 'contains the descendants of the given vertices' do
            @graph.vertices.should include(v2, v3)
          end

          it 'contains all the edges of the included vertices' do
            @graph.edges.should include(@e1, @e2)
          end
        end
      end
    end

    describe '#vertices' do
      it 'is initially empty' do
        graph.vertices.should be_empty
      end

      it 'contains the vertices of the graph' do
        v = vertex.new
        graph.vertices << v

        graph.vertices.should == [v]
      end
    end

    describe '#edges' do
      it 'is initially empty' do
        graph.edges.should be_empty
      end

      it 'contains the edges of the graph' do
        e = edge.new
        graph.edges << e

        graph.edges.should == [e]
      end
    end
  end
end
