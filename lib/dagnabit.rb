require 'active_record'

require 'dagnabit/link/configuration'
require 'dagnabit/link/validations'
require 'dagnabit/link/associations'
require 'dagnabit/link/class_methods'
require 'dagnabit/link/cycle_prevention'
require 'dagnabit/link/named_scopes'
require 'dagnabit/link/transitive_closure_recalculation'
require 'dagnabit/link/transitive_closure_link_model'

require 'dagnabit/node/configuration'
require 'dagnabit/node/class_methods'
require 'dagnabit/node/associations'
require 'dagnabit/node/neighbors'

require 'dagnabit/activation'

ActiveRecord::Base.extend(Dagnabit::Activation)
