module Dagnabit
  module Link
    #
    # Installs a callback into the link model to check for cycles.  If a cycle
    # would be created by the addition of this link, prevents the link from
    # being saved.
    #
    module CyclePrevention
      #
      # Performs cycle detection.  
      #
      def before_save
        super
        check_for_cycles 
      end

      private

      def check_for_cycles
        false if self.class.path?(descendant, ancestor) || descendant == ancestor
      end
    end
  end
end
