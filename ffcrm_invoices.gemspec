$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ffcrm_invoices/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ffcrm_invoices"
  s.version     = FfcrmInvoices::VERSION
  s.authors     = ["Road Tang"]
  s.email       = ["roadtang@gmail.com"]
  s.homepage    = "https://github.com/cloudarena/ffcrm_invoices"
  s.summary     = "Ffcrm Invoices plugin"
  s.description = "New invoice plugin used for new Fatfreecrm"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.2.13"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
