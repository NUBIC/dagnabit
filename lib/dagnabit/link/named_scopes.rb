module Dagnabit
  module Link
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
