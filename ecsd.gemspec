# frozen_string_literal: true

require 'ecsd/version'

Gem::Specification.new do |s|
  s.name        = 'ECSD'
  s.version     = ECSD::VERSION
  s.licenses    = ['MIT']
  s.authors     = ['Anton Shevtsov']
  s.email       = 'shevtsovav@bk.ru'
  s.summary     = 'ECS(EC2 based) discovery'
  s.description = 'Generate ec2 yaml config files to allow ECS cluster to be discovered by prometheus monitoring service'

  s.files       = Dir['CHANGELOG.md', 'LICENSE', 'README.md', 'lib/**/*', 'export']

  s.required_ruby_version = '>= 2.4.0'

  s.add_dependency 'aws-sdk-ec2', ['~> 1.298']
  s.add_dependency 'aws-sdk-ecs', ['~> 1.95']
end
