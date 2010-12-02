database = ENV['DATABASE'] || 'postgresql'

require File.join(File.dirname(__FILE__), %W(connections #{database} connection))
