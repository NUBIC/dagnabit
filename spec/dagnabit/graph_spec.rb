require 'spec_helper'

require 'models/edge'
require 'models/vertex'

module Dagnabit
  describe Graph do
    let(:graph) { Graph.new }
    let(:vertex) { Class.new(::Vertex) }
    let(:edge)   { Class.new(::Edge) }

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
          [:v1, :v2, :v3].each { |v| let(v) { vertex.create } }

          before do
            @e1 = edge.create(:parent_id => v1.id, :child_id => v2.id)
            @e2 = edge.create(:parent_id => v2.id, :child_id => v3.id)
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

    describe '#sources' do
      [:v1, :v2].each { |v| let!(v) { vertex.create } }

      it 'returns all source vertices of the graph' do
        graph.vertices << v1

        graph.sources.should == [v1]
      end

      it 'considers edges' do
        graph.vertices = [v1, v2]
        graph.edges << edge.create(:parent_id => v1.id, :child_id => v2.id)

        graph.sources.should == [v1]
      end
    end

    describe '#sinks' do
      [:v1, :v2].each { |v| let!(v) { vertex.create } }

      it 'returns sink vertices' do
        graph.vertices << v1

        graph.sinks.should == [v1]
      end

      it 'considers edges' do
        graph.vertices = [v1, v2]
        graph.edges << edge.create(:parent_id => v1.id, :child_id => v2.id)

        graph.sinks.should == [v2]
      end
    end

    describe '#load_descendants!' do
      [:v1, :v2, :v3].each { |v| let!(v) { vertex.create } }

      let!(:e1) { edge.create(:parent_id => v1.id, :child_id => v2.id) }
      let!(:e2) { edge.create(:parent_id => v2.id, :child_id => v3.id) }

      before do
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

      it 'eagerly loads edge parents' do
        graph.load_descendants!

        graph.edges.all? { |e| e.loaded_parent? }.should be_true
      end

      it 'eagerly loads edge children' do
        graph.load_descendants!

        graph.edges.all? { |e| e.loaded_child? }.should be_true
      end
    end
  end
end
