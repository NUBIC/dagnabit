module Dagnabit
  module Link
    #
    # Builds a model for transitive closure tuples.
    #
    # The transitive closure model is generated inside the link class.
    # Therefore, if your link model class was called Link, the transitive
    # closure model would be named Link::(class name here).  The name of the
    # transitive closure model class is determined when the link class model is
    # activated; see Dagnabit::Activation#acts_as_dag_link for more information.
    #
    # == Model class details
    # 
    # === Construction details
    #
    # The transitive closure model is constructed as a subclass of
    # ActiveRecord::Base, _not_ as a subclass of your link model class.  The
    # transitive closure model also acts as a dag link (via
    # Dagnabit::Activation#acts_as_dag_link) and is configured using the same
    # configuration options as your link model class.
    #
    # This means:
    #
    # * The transitive closure tuple table and your link table must have the
    #   same column names for ancestor id/type and descendant id/type.
    # * You will not be able to use any methods defined on your link model on
    #   the transitive closure model.
    #
    # === Available methods
    #
    # The following class methods are available on transitive closure link
    # models:
    #
    # [linking(a, b)]
    #   Returns all links (direct or indirect) linking +a+ and +b+.  
    # [ancestor_type(type)]
    #   Behaves identically to the ancestor_type named scope defined in
    #   Dagnabit::Link::NamedScopes.
    # [descendant_type(type)]
    #   Behaves identically to the descendant_type named scope defined in
    #   Dagnabit::Link::NamedScopes.
    #
    # The following instance methods are available on transitive closure link
    # models:
    #
    # [ancestor]
    #   Returns the ancestor of this link.  Behaves identically to the
    #   ancestor association defined in Dagnabit::Link::Associations.
    # [descendant]
    #   Returns the descendant of this link.  Behaves identically to the
    #   descendant association defined in Dagnabit::Link::Associations.
    #
    module TransitiveClosureLinkModel
      attr_reader :transitive_closure_class

      private

      #
      # Generates the transitive closure model.
      #
      def generate_transitive_closure_link_model(options)
        original_class = self

        klass = Class.new(ActiveRecord::Base) do
          extend Dagnabit::Link::Configuration

          configure_acts_as_dag_link(options)
          set_table_name original_class.unquoted_transitive_closure_table_name
        end

        @transitive_closure_class = const_set(transitive_closure_class_name, klass)

        # reflections and named scopes aren't properly created in anonymous
        # models, so we need to do that work after the model has been named
        @transitive_closure_class.extend(Dagnabit::Link::Associations)
        @transitive_closure_class.extend(Dagnabit::Link::NamedScopes)
        @transitive_closure_class.named_scope :linking, lambda { |from, to|
            { :conditions => { ancestor_id_column => from.id,
                               ancestor_type_column => from.class.name,
                               descendant_id_column => to.id,
                               descendant_type_column => to.class.name } }
        }
      end
    end
  end
end
