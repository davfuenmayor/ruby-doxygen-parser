require "rubygems"
require "bundler/setup"

require 'nokogiri'
require 'fileutils'

require_relative 'exception'
require_relative 'util'
require_relative 'nodes/node'
require_relative 'nodes/compound'
require_relative 'nodes/param'
require_relative 'nodes/member'
require_relative 'nodes/struct'
require_relative 'nodes/class'
require_relative 'nodes/enum'
require_relative 'nodes/hfile'
require_relative 'nodes/function'
require_relative 'nodes/group'
require_relative 'nodes/namespace'
require_relative 'nodes/variable'


module Doxyparser

  class << self
    def parse_namespace basename, directory
      Doxyparser::Namespace.new :name => basename, :dir => directory
    end

    def parse_group basename, directory
      Doxyparser::Group.new :name => basename, :dir => directory
    end

    def parse_class basename, directory
      Doxyparser::Class.new :name => basename, :dir => directory
    end

    def parse_struct basename, directory
      Doxyparser::Struct.new :name => basename, :dir => directory
    end

    def parse_header_file basename, directory
      Doxyparser::HFile.new :name => basename, :dir => directory
    end
  end
end
