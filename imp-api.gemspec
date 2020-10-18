require_relative 'lib/imp/version'

Gem::Specification.new do |spec|
  spec.name          = "imp-api"
  spec.version       = IMP::VERSION
  spec.authors       = ["patztablook22"]
  spec.email         = ["patz@tuta.io"]

  spec.summary       = "API for Intelligently Managed Packages"
  spec.description   = "Intelligent and pluginable Package Manager"
  spec.homepage      = "https://github.com/imp-package-manager/imp-api"
  spec.license       = "GPL-3.0"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")
  spec.add_development_dependency "rspec", "~> 3.2"

=begin
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."
=end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
