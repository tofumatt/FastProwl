require 'rake'

Gem::Specification.new do |s|
  s.name = "fastprowl"
  s.version = "0.1"
  s.date = Time.now
  s.authors = ["Matthew Riley MacPherson"]
  s.email = "matt@lonelyvegan.com"
  s.has_rdoc = true
  s.rdoc_options << '--title' << "FastProwl - Ruby library for Ruby using libcurl-multi for parallel requests" << '--main' << 'README.markdown' << '--line-numbers'
  s.summary = "Prowl library for Ruby using libcurl-multi for parallel requests"
  s.homepage = "http://github.com/tofumatt/FastProwl"
  s.files = FileList['lib/*.rb', '[A-Z]*', 'fastprowl.gemspec', 'test/*.rb'].to_a
  s.test_file = 'test/fastprowl.rb'
  s.add_dependency('typhoeus')
  s.add_development_dependency('mocha') # Used to run the tests, that's all...
end
