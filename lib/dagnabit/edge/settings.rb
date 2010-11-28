require File.join(File.dirname(__FILE__), %w(.. edge))

module Dagnabit::Edge
  module Settings
    def vertex_table
      @vertex_table || 'vertices'
    end

    def set_vertex_table(name)
      @vertex_table = name
    end
  end
end
