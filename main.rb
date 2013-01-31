#!/usr/bin ruby
require_relative 'rswig'
require 'fileutils'

$dirname=File.expand_path(File.dirname(__FILE__))
if Dir.exists? "./output" 
  FileUtils.rm_r "./output"
end
swig_dir=$dirname+"/output/swig_include"
FileUtils.mkdir_p swig_dir

idir=$dirname+"/headers"
# Opens Log
logfile="rswig.log"
$log = File.open(logfile, "w")

# Parses csv interface data
columns, table=parse_csv(idir+"/rswig_input.csv")
puts table
# Generate Namespace Classes from hashes
api_namespaces=generate_classes(table)
  # For debugging
print_api_namespaces(api_namespaces)

# Directories to search for .h files
idirs=[idir]


# Parses all .h files from the specified directories
source = parse_inc_files(idirs)

# Generates a directory for every namespace 
# and saves in this directory the generated swig files
api_namespaces.each do |api_ns|
  
  
  # Gets native namespace  
  namespace=source.namespaces(api_ns.wnamespace)
  
  # Gets Target classes to wrap from this namespace
  api_cls=api_ns.api_classes
  
  # Gets all classes from the namespace
  lst_classes = namespace.classes
  
  # Gets a list of include file objects grouping those classes
  incl_files=group_classes(api_cls, lst_classes)
  
  # For debugging
  print_incl_files(incl_files)
  
  
  out_dir= swig_dir+"/"+api_ns.wnamespace
  
  # Creates a SWIG interface file for every include file object  
  incl_files.each { |i|
    
    FileUtils.mkdir_p(out_dir)
    interface_file=create_interface_file(i, out_dir, api_ns.name)
  }
  
  # Runs SWIG in the specified directory
  # swig #{swig_opts} #{include_dirs} ./#{swig_include}/#{f} 
  gen_dir=File.expand_path(swig_dir+"/../gen/"+api_ns.name)
  FileUtils.mkdir_p(gen_dir)
  run_swig(out_dir,gen_dir)

end

$log.close()
