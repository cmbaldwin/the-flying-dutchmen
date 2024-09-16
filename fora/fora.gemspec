lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fora/version'

Gem::Specification.new do |spec|
  spec.name = 'fora'
  spec.version = Fora::VERSION
  spec.authors = ['Chris Oliver', 'Cody Baldwin']
  spec.email = ['codybaldwin@gmail.com']

  spec.summary = 'A modified fork of the simple_discussion forum.'
  spec.description = "Fora is the plural of the greek word 'forum'."
  spec.homepage = 'https://github.com/cmbaldwin/fora'
  spec.license = 'MIT'

  begin
    spec.files = `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  rescue Errno::ENOENT
    spec.files = Dir.glob('**/*').reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  end

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'bootstrap-icons-helper'
  spec.add_dependency 'friendly_id'
  spec.add_dependency 'rails'
  spec.add_dependency 'will_paginate'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
