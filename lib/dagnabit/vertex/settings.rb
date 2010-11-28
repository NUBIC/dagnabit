require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  module Settings
    def edge_table
      @edge_table || 'edges'
    end

    def set_edge_table(name)
      @edge_table = name
    end
  end
end
