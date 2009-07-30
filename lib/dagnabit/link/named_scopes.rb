module Dagnabit
  module Link
    #
    # Adds named scopes to Link models.
    #
    # This module provides two named scopes for finding links scoped by
    # ancestor and descendant type.  They were designed as support for node
    # neighbor queries such as ancestors_of_type and descendants_as_type, but
    # can be used on their own.
    #
    # These links are imported into the generated transitive closure link model.
    # See Dagnabit::Link::TransitiveClosureLinkModel for more information.
    #
    # == Supplied scopes
    #
    # [ancestor_type]
    #   Returns all links having a specified ancestor type.
    #
    # [descendant_type]
    #   Returns all links having a specified descendant type.
    #
    # == A note on type matching
    #
    # Types are stored in links using ActiveRecord's polymorphic association
    # typing logic, and are matched using string matching.  Therefore, subclass
    # matching and namespacing aren't provided.
    #
    # To elaborate on this, let's say you have the following model structure:
    #
    #   class Link < ActiveRecord::Base
    #     acts_as_dag_link
    #   end
    #
    #   module Foo
    #     class Bar < ActiveRecord::Base
    #       ...
    #     end
    #   end
    #
    # A link linking Foo::Bars will record Foo::Bar as ancestor or descendant
    # type, not just 'Bar'.  The following will therefore not work:
    #
    #   Link.ancestor_type('Bar')
    #
    # You have to do:
    #
    #   Link.ancestor_type('Foo::Bar')
    #
    # or, if you'd like to hide the details of deriving a full class name:
    #
    #   Link.ancestor_type(Bar.name)
    #
    module NamedScopes
      def self.extended(base)
        base.send(:named_scope,
                  :ancestor_type,
                  lambda { |type| { :conditions => { :ancestor_type => type } } })

        base.send(:named_scope,
                  :descendant_type,
                  lambda { |type| { :conditions => { :descendant_type => type } } })
      end
    end
  end
end
