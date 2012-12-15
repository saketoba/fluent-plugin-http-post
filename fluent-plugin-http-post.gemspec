# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-http-post"
  gem.version       = "0.1.0"
  gem.authors       = ["saketoba"]
  gem.email         = ["ainonic@gmail.com"]
  gem.summary       = %q{output plugin for HTTP post request}
  gem.description   = %q{output plugin for HTTP post request}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "fluentd"
  gem.add_runtime_dependency "fluentd"
end
