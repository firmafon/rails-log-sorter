$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails-log-sorter"
  s.version     = "0.1"
  s.authors     = ["Harry Vangberg"]
  s.email       = ["hv@firmafon.dk"]
  s.homepage    = "https://github.com/firmafon/rails-log-sorter"
  s.summary     = "Sort log files"
  s.description = "Sort log files"

  s.files = Dir["lib/**/*"]
  s.test_files = Dir["test/**/*"]
end
