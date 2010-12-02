require File.join(File.dirname(__FILE__), %w(.. vertex))

module Dagnabit::Vertex
  ##
  # Contains parameters that can be customized on a per-vertex-model basis.
  module Settings
    ##
    # The edge model associated with a vertex model.  Defaults to `Edge`.
    #
    # @return [Class] the edge model
    def edge_model
      (@edge_model_name || 'Edge').constantize
    end

    ##
    # The edge table used by connectivity queries.  Equivalent to
    #
    #     edge_model.table_name
    #
    # @return [String] the name of the edge table
    def edge_table
      edge_model.table_name
    end

    ##
    # Sets or retrieves the name of the edge model associated with a vertex.
    #
    # If invoked with no arguments or nil, returns the name of the currently
    # set edge model.  Otherwise, sets the edge model to what is given in
    # `edge_model_name`.
    #
    # {#edge_model} uses ActiveSupport's `constantize` method to look up the
    # model from `edge_model_name`.
    #
    # @param [String] edge_model_name the name of the edge model to use
    # @return [String] the name of the edge model
    def connected_by(edge_model_name = nil)
      edge_model_name ? @edge_model_name = edge_model_name : @edge_model_name
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
      subclass.connected_by(connected_by)
    end
  end
end
