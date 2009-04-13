require 'dagnabit/link/transitive_closure_recalculation/on_create'
require 'dagnabit/link/transitive_closure_recalculation/on_destroy'
require 'dagnabit/link/transitive_closure_recalculation/on_update'

module Dagnabit
  module Link
    module TransitiveClosureRecalculation
      include OnCreate
      include OnDestroy
      include OnUpdate
    end
  end
end
