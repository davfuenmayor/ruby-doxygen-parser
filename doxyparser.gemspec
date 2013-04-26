# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'doxyparser'
  s.version     = '0.9.6'
  s.platform    = Gem::Platform::RUBY
  s.date        = '2013-04-26'
  s.summary     = "Ruby library that uses Doxygen XML output to parse and query C++ header files"  
  s.authors     = ["David Fuenmayor"]
  s.email       = ["davfuenmayor@gmail.com"]
  s.description = <<-END
This library is based on Nokogiri (http://nokogiri.org) and takes as input the xml directory previously generated by Doxygen (www.doxygen.org).
Using Doxygen allows us to parse even a set of non-compilable include files. This is very useful in case you need to parse only a subset of a big library which doesn't compile because of being incomplete or needing configuration through Makefiles, CMake, etc. In those cases parsing with gccxml, swig or others would throw lots of compilation errors.
  END
  
  patterns = [
    'README.md',
    'MIT_LICENSE',
    'lib/**/*.rb',
  ]
  s.files = patterns.map {|p| Dir.glob(p) }.flatten
  s.homepage    =
    'https://github.com/davfuenmayor/ruby-doxygen-parser'
    
  s.test_files = Dir.glob('spec/**/*.rb')

  s.require_paths = ['lib']
  s.license = 'MIT'
end
