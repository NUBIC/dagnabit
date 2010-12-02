$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), %w(.. .. lib)))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), %w(.. .. db)))

require 'dagnabit'

require 'connection'
require 'schema'

require 'models/edge'
require 'models/vertex'

Before do
  c = ActiveRecord::Base.connection

  c.tables.each do |t|
    c.execute("TRUNCATE TABLE #{c.quote_table_name(t)} CASCADE")
  end
end
