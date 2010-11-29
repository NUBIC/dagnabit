require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit
  describe Graph do
    let(:graph) { Graph.new }
    let(:vertex) { Class.new(::Vertex) }
    let(:edge)   { ::Edge[::Vertex] }

    before do
      vertex.extend(Vertex::Connectivity)
      edge.extend(Edge::Connectivity)
    end

    describe '.from_vertices' do
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

    describe '#load_descendants!' do
      [:v1, :v2, :v3].each { |v| let(v) { vertex.new } }

      let(:e1) { edge.new(:parent => v1, :child => v2) }
      let(:e2) { edge.new(:parent => v2, :child => v3) }

      before do
        e1.save
        e2.save

        graph.vertices << v1
        graph.vertex_model = vertex
        graph.edge_model = edge
      end

      it 'requires vertex_model to be set' do
        graph.vertex_model = nil

        lambda { graph.load_descendants! }.should raise_error(RuntimeError)
      end

      it 'requires edge_model to be set' do
        graph.vertex_model = vertex
        graph.edge_model = nil

        lambda { graph.load_descendants! }.should raise_error(RuntimeError)
      end

      it 'loads all descendants of the vertices in the graph' do
        graph.load_descendants!

        graph.vertices.should be_set_equivalent_to(v1, v2, v3)
      end

      it 'loads all edges connecting the loaded descendants' do
        graph.load_descendants!

        graph.edges.should be_set_equivalent_to(e1, e2)
      end
    end
  end
end
