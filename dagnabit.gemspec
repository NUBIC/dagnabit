# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dagnabit/version"

Gem::Specification.new do |s|
  s.name          = "dagnabit"
  s.version       = Dagnabit::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["David Yip", "Turadg Aleahmad"]
  s.email         = ["yipdw@member.fsf.org", "turadg@geknowm.com"]
  s.homepage      = "http://rubygems.org/gems/dagnabit"
  s.summary       = %q{Directed acyclic graph plugin for ActiveRecord/PostgreSQL}
  s.description   = %q{Directed acyclic graph support library for applications using ActiveRecord on top of PostgreSQL.}
  s.files         = Dir.glob("{*.md,LICENSE,lib/**/*,bin/dagnabit-test,db/**/*}")
  s.executables   = ["dagnabit-test"]
  s.require_paths = ["lib"]

  s.add_dependency  'activerecord', ['> 3.0', '< 4.1']

  [
    [ 'ZenTest',    '~> 4.5.0' ],
    [ 'bluecloth',  nil        ],
    [ 'cucumber',   nil        ],
    [ 'pg',         nil        ],
    [ 'rake',       nil        ],
    [ 'rspec',      '~> 2.0'   ],
    [ 'yard',       nil        ]
  ].each do |gem, version|
    s.add_development_dependency gem, version
  end
end
