require File.join(File.dirname(__FILE__), %w(.. dagnabit))

module Dagnabit
  ##
  # Contains shorthand for setting up database triggers and constraints for
  # maintaining dagnabit's invariants.  See the README for more information.
  #
  # This module is intended to be extended by subclasses of
  # ActiveRecord::Migration.
  module Migration
    ##
    # Instantiates a cycle check trigger on `edge_table`.  The trigger is
    # executed on a per row basis for every insert or update.
    #
    # @param [Symbol, String] edge_table the table for the trigger
    # @return [void]
    def create_cycle_check_trigger(edge_table)
      create_cycle_check_function(edge_table)

      execute %Q{
        CREATE TRIGGER #{trigger_name} AFTER INSERT OR UPDATE ON #{edge_table}
          FOR EACH ROW EXECUTE PROCEDURE #{function_name}_#{edge_table}();
      }.strip
    end

    ##
    # Drops a trigger created by {#create_cycle_check_trigger}.
    #
    # @param [Symbol, String] edge_table the table owning the trigger
    # @return [void]
    def drop_cycle_check_trigger(edge_table)
      execute %Q{
        DROP TRIGGER #{trigger_name} ON #{edge_table};
      }.strip

      drop_cycle_check_function(edge_table)
    end

    ##
    # Builds a PL/pgSQL function for performing cycle checks.
    #
    # If the function already exists, then calling this method will overwrite
    # it.
    #
    # A `CREATE TRUSTED LANGUAGE plpgsql` declaration must have been made in the
    # database prior to invocation of {#create_cycle_check_function}.
    #
    # @param [Symbol, String] edge_table the table to check
    # @return [void]
    def create_cycle_check_function(edge_table)
      execute %Q{
        CREATE OR REPLACE FUNCTION #{function_name}_#{edge_table}() RETURNS trigger AS $#{function_name}$
          DECLARE
            cyclic bool;
          BEGIN
            WITH RECURSIVE cycles(id, path, cycle) AS (
              SELECT e.child_id, ARRAY[]::integer[], false
                FROM #{edge_table} e WHERE e.parent_id = NEW.parent_id
              UNION ALL
              SELECT e.child_id, c.path || c.id, c.id = ANY(c.path)
                FROM cycles c INNER JOIN #{edge_table} e ON e.parent_id = c.id AND NOT cycle
            )
            SELECT true FROM cycles WHERE cycle = true INTO cyclic;

            IF cyclic = true THEN
              RAISE EXCEPTION 'Edge (%, %) introduces a cycle', NEW.child_id, NEW.parent_id;
            END IF;

            RETURN NULL;
          END;
        $#{function_name}$ LANGUAGE plpgsql;
      }.strip
    end
    
    ##
    # Drops the function created by {#create_cycle_check_function}.
    #
    # It is safe to call this method if the function was not previously
    # created.
    #
    # @return [void]
    def drop_cycle_check_function(edge_table)
      execute %Q{
        DROP FUNCTION IF EXISTS #{function_name}_#{edge_table}();
      }.strip
    end

    private

    def trigger_name
      'dagnabit_cycle_check'
    end

    def function_name
      'dagnabit_cycle_check'
    end
  end
end
