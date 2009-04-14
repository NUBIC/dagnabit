# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dagnabit}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Yip"]
  s.date = %q{2009-04-13}
  s.email = %q{yipdw@northwestern.edu}
  s.files = ["README.rdoc", "VERSION.yml", "lib/dagnabit", "lib/dagnabit/activation.rb", "lib/dagnabit/link", "lib/dagnabit/link/associations.rb", "lib/dagnabit/link/class_methods.rb", "lib/dagnabit/link/configuration.rb", "lib/dagnabit/link/cycle_prevention.rb", "lib/dagnabit/link/transitive_closure_link_model.rb", "lib/dagnabit/link/transitive_closure_recalculation", "lib/dagnabit/link/transitive_closure_recalculation/on_create.rb", "lib/dagnabit/link/transitive_closure_recalculation/on_destroy.rb", "lib/dagnabit/link/transitive_closure_recalculation/on_update.rb", "lib/dagnabit/link/transitive_closure_recalculation/utilities.rb", "lib/dagnabit/link/transitive_closure_recalculation.rb", "lib/dagnabit/link/validations.rb", "lib/dagnabit.rb", "test/connections", "test/connections/native_sqlite3", "test/connections/native_sqlite3/connection.rb", "test/dagnabit", "test/dagnabit/link", "test/dagnabit/link/test_associations.rb", "test/dagnabit/link/test_class_methods.rb", "test/dagnabit/link/test_configuration.rb", "test/dagnabit/link/test_cycle_prevention.rb", "test/dagnabit/link/test_transitive_closure_link_model.rb", "test/dagnabit/link/test_transitive_closure_recalculation.rb", "test/dagnabit/link/test_validations.rb", "test/dagnabit/node", "test/debug.log", "test/schema", "test/schema/schema.rb", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/yipdw/dagnabit}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{TODO}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 2.1.0"])
    else
      s.add_dependency(%q<activerecord>, [">= 2.1.0"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 2.1.0"])
  end
end
