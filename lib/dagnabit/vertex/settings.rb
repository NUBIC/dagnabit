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
    # The edge model associated with a vertex model.  Defaults to nil.
    #
    # Connectivity queries do not use this model; however, some Vertex modules,
    # such as {Bonding}, do.  If you do not intend to use any of those modules,
    # it is safe to leave this as nil.
    #
    # @return [Class] the edge model
    def edge_model
      @edge_model
    end

    ##
    # Sets the edge model.
    #
    # Setting this will also set the edge table to the return value of
    #
    #     model.table_name
    # .
    #
    # @param [#table_name] model an ActiveRecord::Base subclass
    def set_edge_model(model)
      @edge_model = model

      set_edge_table(model.table_name) if model
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
      subclass.set_edge_model(edge_model)
    end
  end
end
