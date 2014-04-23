require "rubygems"

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
require_relative 'nodes/enum_value'
require_relative 'nodes/enum'
require_relative 'nodes/hfile'
require_relative 'nodes/function'
require_relative 'nodes/namespace'
require_relative 'nodes/variable'


module Doxyparser

  class << self
  	
  	# Retrieves metadata for a given Namespace
    # @param basename [String] Name of the namespace to parse (for instance: NamespaceA::NamespaceB)
    # @param xml_dir [String] Path to the directory with the generated intermediate XML representation
    # @return [Namespace] A tree of objects representing the namespace and its members (classes, structs, enums, etc)
    def parse_namespace basename, xml_dir
      Doxyparser::Namespace.new :name => basename, :dir => xml_dir
    end

		# Retrieves metadata for a given Class
    # @param basename [String] Name of the class to parse (for instance: MyNamespace::MyClass)
    # @param xml_dir [String] Path to the directory with the generated intermediate XML representation
    # @return [Class] A tree of objects representing the class and its members (attributes, methods, innerclasses, etc) 
    def parse_class basename, xml_dir
      Doxyparser::Class.new :name => basename, :dir => xml_dir
    end

		# Retrieves metadata for a given Struct
    # @param basename [String] Name of the struct to parse (for instance: MyNamespace::MyStruct)
    # @param xml_dir [String] Path to the directory with the generated intermediate XML representation
    # @return [Struct] A tree of objects representing the struct and its members (attributes, methods, enums, etc) 
    def parse_struct(basename, xml_dir)
      Doxyparser::Struct.new :name => basename, :dir => xml_dir
    end
    
		# Retrieves metadata for a given header file
    # @param basename [String] Name of the header file to parse (for instance: myheader.h)
    # @param xml_dir [String] Path to the directory with the generated intermediate XML representation
    # @return [HFile] A tree of objects representing the header file and its contents (classes, functions, enums, etc)
    def parse_file(basename, xml_dir)
      Doxyparser::HFile.new :name => basename, :dir => xml_dir
    end
    
    # Generates intermediate XML representation for a group of header files
    # @param source_dirs [Array<String>, String] Input source directory (or directories)
    # @param xml_dir [String] Output Directory for the generated XML documents
    # @param recursive if present (and not nil) sets the RECURSIVE FLAG in Doxygen. Subdirectories will also be searched 
    # @param include_dirs [Array<String>, String] Adds given directories to Doxygen's INCLUDE_PATH (Doxyfile variable)
    # @param generate_html if present (and not nil) HTML documentation will also be generated 
    # @param stl_support if present (and not nil) sets the BUILTIN_STL_SUPPORT flag in Doxygen. Special support for STL Libraries
    def gen_xml_docs(source_dirs, xml_dir, recursive = nil, include_dirs = nil, generate_html = nil, stl_support = 1)
    	
    	if include_dirs.nil? || include_dirs.empty?
    		inc_dirs = ''
    	else
    		if include_dirs.is_a? Array
    			inc_dirs = include_dirs.join(' ')
    		else
    			inc_dirs = include_dirs
    		end
    	end
    	if source_dirs.is_a? Array
    		proj_name = File.basename(source_dirs[0])
    		src_dirs = source_dirs.join(' ')
    	else
    		proj_name = File.basename(source_dirs)
    		src_dirs = source_dirs
    	end
    	
    	recursive = recursive ? 'YES' : 'NO'    	
    	home_dir = Doxyparser::Util.home_dir
    	gen_html = generate_html ? 'YES' : 'NO'
    	stl_support = stl_support ? 'YES' : 'NO'
      doxyfile =  "# Doxyfile 1.7.6.1\n\n"
      doxyfile << "# Project related configuration options\n\n"
      doxyfile << %Q{PROJECT_NAME\t\t= "#{proj_name}"\nINPUT\t\t\t\t= #{src_dirs}\nGENERATE_HTML\t\t= #{gen_html}\n}
      doxyfile << %Q{RECURSIVE\t\t\t= #{recursive}\nINCLUDE_PATH\t\t= #{inc_dirs}\nBUILTIN_STL_SUPPORT\t= #{stl_support}\n}
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
