module Dagnabit
  module Activation
    def acts_as_dag_link(options = {})
      extend Dagnabit::Link::Configuration
      configure_acts_as_dag_link(options)
      augment_link_model
    end
    
    private

    def augment_link_model
      extend Dagnabit::Link::ClassMethods
      extend Dagnabit::Link::Associations
      include Dagnabit::Link::TransitiveClosureRecalculation
    end
  end
end
