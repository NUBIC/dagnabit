require 'dagnabit/link/transitive_closure_recalculation/on_create'
require 'dagnabit/link/transitive_closure_recalculation/on_destroy'
require 'dagnabit/link/transitive_closure_recalculation/on_update'

module Dagnabit
  module Link
    #
    # Code to do the heavy lifting of maintaining the transitive closure of the
    # dag after edge create, destroy, and update.
    # 
    module TransitiveClosureRecalculation
      include OnCreate
      include OnDestroy
      include OnUpdate
    end
  end
end
