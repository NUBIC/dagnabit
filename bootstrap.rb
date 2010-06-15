begin
  require File.join(File.dirname(__FILE__), %w(.bundle environment))
rescue LoadError
  abort 'Locked gem environment not found.  Run "bundle lock".'
end
