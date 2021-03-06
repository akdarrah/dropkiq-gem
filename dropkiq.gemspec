
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dropkiq/version"

Gem::Specification.new do |spec|
  spec.name          = "dropkiq"
  spec.version       = Dropkiq::VERSION
  spec.authors       = ["Adam Darrah"]
  spec.email         = ["adam@dropkiq.com"]

  spec.summary       = %q{Integrate your Ruby on Rails application with Dropkiq for easy Liquid editing}
  spec.description   = %q{Dropkiq simplifies the creation of Liquid (from Shopify) expressions. The Dropkiq Ruby Gem automates the maintenance of fixtures within Dropkiq to allow for testing Liquid expressions.}
  spec.homepage      = "https://github.com/akdarrah/dropkiq-gem"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  #
  #   spec.metadata["homepage_uri"] = spec.homepage
  #   spec.metadata["source_code_uri"] = "https://github.com/akdarrah/dropkiq-gem"
  #   spec.metadata["changelog_uri"] = "https://github.com/akdarrah/dropkiq-gem"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "pry", "~> 0.12.2"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.13"
  spec.add_development_dependency "mocha", "~> 1.11.2"
  spec.add_development_dependency "minitest-focus", "~> 1.1.2"

  spec.add_dependency "activerecord", ">= 4.2"
  spec.add_dependency "liquid", "~> 4.0"
end
