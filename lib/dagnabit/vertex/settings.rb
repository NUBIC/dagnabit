require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # Contains parameters that can be customized on a per-vertex-model basis.
  module Settings
    ##
    # The edge table used by connectivity queries.  Defaults to "edges".
    #
    # @return [String] the name of the edge table
    def edge_table
      @edge_table || 'edges'
    end

    ##
    # Sets the edge table used by connectivity queries.
    # 
    # @param [String] name a table name
    def set_edge_table(name)
      @edge_table = name
    end

    ##
    # This callback ensures that whenever a class that extends Settings is
    # inherited, the settings for the superclass are passed to the subclass.
    #
    # This callback executes any previously-defined definitions of `inherited`
    # beforee executing its own code.
    # 
    # @param [Class] subclass the descendant class
    def inherited(subclass)
      super
      subclass.set_edge_table(edge_table)
    end
  end
end
