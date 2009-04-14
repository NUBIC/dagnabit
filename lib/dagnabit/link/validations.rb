module Dagnabit
  module Link
    module Validations
      def self.extended(base)
        base.send(:validates_presence_of, :ancestor)
        base.send(:validates_presence_of, :descendant)
      end
    end
  end
end
