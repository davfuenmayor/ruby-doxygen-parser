require "rubygems"
require "bundler/setup"

require 'nokogiri'
require 'fileutils'

require_relative 'util'
require_relative 'nodes/node'
require_relative 'nodes/compound'
require_relative 'nodes/type'
require_relative 'nodes/param'
require_relative 'nodes/member'
require_relative 'nodes/typedef'
require_relative 'nodes/friend'
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
    def parse_namespace basename, xml_dir
      Doxyparser::Namespace.new :name => basename, :dir => xml_dir
    end

    def parse_group basename, xml_dir
      Doxyparser::Group.new :name => basename, :dir => xml_dir
    end

    def parse_class basename, xml_dir
      Doxyparser::Class.new :name => basename, :dir => xml_dir
    end

    def parse_struct basename, xml_dir
      Doxyparser::Struct.new :name => basename, :dir => xml_dir
    end

    def parse_file basename, xml_dir
      Doxyparser::HFile.new :name => basename, :dir => xml_dir
    end
    
    def gen_xml_docs src_dir, xml_dir, recursive = nil, include_dirs = nil, generate_html = nil
    	
    	if include_dirs.nil? || include_dirs.empty?
    		inc_dirs = ''
    	else
    		inc_dirs = include_dirs.join(', ')
    	end
    	recursive = recursive ? 'YES' : 'NO'
    	
    	home_dir = Doxyparser::Util.home_dir
    	gen_html = generate_html ? 'YES' : 'NO'
    	proj_name = File.basename src_dir
      doxyfile =  "# Doxyfile 1.7.6.1\n\n"
      doxyfile << "# Project related configuration options\n\n"
      doxyfile << %Q{PROJECT_NAME\t\t= "#{proj_name}"\nINPUT\t\t\t\t= #{src_dir}\nGENERATE_HTML\t\t= #{gen_html}\n}
      doxyfile << %Q{RECURSIVE\t\t\t= #{recursive}\nINCLUDE_PATH\t\t= #{inc_dirs}\n\n}
      doxyfile << "# Default doxygen configuration options\n\n"
      doxyfile << Doxyparser::Util.read_file(home_dir+'/resources/Doxyfile')
      doxyfile_path = xml_dir+'/Doxyfile'
      FileUtils.mkdir_p(xml_dir)
      Doxyparser::Util.write_file(doxyfile_path, doxyfile)      
      Dir.chdir(xml_dir)
      command = %Q{doxygen < #{doxyfile_path}}
      output = IO.popen(command)
      output.readlines
    end
  end
end
