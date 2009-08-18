module Dagnabit
  module Link
    #
    # Basic validations on link models.
    #
    # This module only installs ancestor and descendant presence validations;
    # the only basic requirement for a link is that it have a valid start point
    # and a valid end point.  We validate the presence of the +ancestor+ and
    # +descendant+, instead of +ancestor_id+ and +descendant_id+, in order to
    # permit scenarios like this:
    #
    #   n1 = Node.new
    #   n2 = Node.new
    #   l = Link.new(:ancestor => n1, :descendant => n2)
    #   l.save  # will save l, n1, and n2
    #
    module Validations
      def self.extended(base)
        base.send(:validates_presence_of, :ancestor)
        base.send(:validates_presence_of, :descendant)
        base.send(:validates_associated, :ancestor)
        base.send(:validates_associated, :descendant)
      end
    end
  end
end
