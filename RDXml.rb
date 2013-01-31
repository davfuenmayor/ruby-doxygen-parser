#!/usr/bin ruby
require 'rubygems'
require 'nokogiri'
#require 'ruby-debug'

$log=nil


def log(msg)
  if $log==nil
    puts "WARNING: No Log found"
  else
    $log.puts(msg+"\n")
  end
  puts msg
end

def parse_inc_files(inc_dirs)
 dirs=[]
 inc_dirs.each do |dir|
   dirs << dir+"/*.h"
 end
 RbGCCXML.parse(dirs)    
end

def parse_csv(file)
  File.open(file) do|f|    
    columns = {}
    table = []
    aux = f.readline
    
    var = aux.chomp.split(',')
   
    until var[0]==nil || var[0].empty?
      columns[var[0]] = var[1..-1]
      var = f.readline.chomp.split(',')
    end        
    until f.eof?
      row = f.readline.chomp.split(',')
      rowtype=row[0]
      row = columns[rowtype].zip(row[1..-1]).flatten
      table << Hash[:type,rowtype,*row]
    end
    return columns, table
  end
end

def generate_classes(table)
  obj=nil
  namespaces=[]
  last_ns=nil
  last_class=nil
  
  table.each{ |type|
    
    case type[:type]
      when "namespace"
        puts "namespace"
        obj=ApiNamespace.new.from_hash(type)
        last_ns=obj
        namespaces << obj
      when "class"
        puts "class"
        obj=ApiClass.new.from_hash(type)
        last_class=obj
        last_ns.api_classes << obj
      when "method"
        puts "method"
        obj=ApiMethod.new.from_hash(type)
        last_class.api_methods << obj
      when "var"
        puts "var"
        obj=ApiVar.new.from_hash(type)
        last_class.api_vars << obj
      else
    end      
  }
  namespaces
end

def set_ignored_classes(incl_file, all_cls)
  puts "Ignoring Classes:  " + incl_file.name
  incl_file.ignored_classes= all_cls - incl_file.api_classes.map{|api_cls| api_cls.wclass}
end

def group_classes(api_cls, lst_classes)

  incl_files= Hash.new

  api_cls.each do |api_c|
    clazz=lst_classes.find(:name => /^#{api_c.name}$/i)
    if clazz==nil
      log("WARNING: Class not found: #{api_cls.name}")
      next
    end
    if clazz.is_a? Array      
      if clazz.empty?
        log("WARNING: Class not found: #{api_cls.name}")
        next
      end 
      log("WARNING: Found several matching classes for #{api_cls.name}:"+clazz.join+"\nKeeping only the first match")
      clazz=clazz[0]
    end
      
    api_c.assoc_with_class(clazz)    
    
    filename=clazz.file    
     puts "filename:************************  " + filename
           
    if incl_files[filename]==nil
        incl_files[filename]=IncFile.new.name_(filename)
        api_c.incfile= incl_files[filename]
    end
    incl_files[filename].api_classes << api_c
  end
  incl_files.each_value{ |f|
    set_ignored_classes(f, lst_classes)
  }
  incl_files.values
end

def read_file(file_name)
  file = File.open(file_name, "r")
  data = file.read
  file.close
  return data
end

def write_file(file_name, data)
  file = File.open(file_name, "w")
  count = file.write(data)
  file.close  
  return count
end

def generate_header_imports
  text=read_file "./headers/HeaderImports"
  header=""
  text.each_line do |line|
    header+="%import "+ %Q{"#{line.chop}"} +"\n"
  end
  header
end

def generate_swig_template(module_name)
  header=%Q{\n%module "#{module_name}"\n}
  header << read_file("./SWIGFiles/StdHeader.i") +"\n"
end


def generate_ignores
  %Q{%ignore "";\n}
end


def create_interface_file(incl_file, output_dir, module_name)
  
interface_file=""

  interface_file << generate_swig_template(module_name)
  interface_file << generate_header_imports
  #interface_file << generate_ignores
  
  incl_file.ignored_classes.each { |cls|
      interface_file << %Q{%rename("$ignore") #{cls.name};} + "\n"
      #interface_file << %Q{%rename("%s") #{cls.name}::#{cls.name};} + "\n"
      #interface_file << %Q{%rename("%s") #{cls.name}::~#{cls.name};} + "\n"
  }
  incl_file.api_classes.each { |api_cls|   
      api_cls.ignored_methods.each{ |m|
         interface_file << %Q{%rename("$ignore") #{m.name};} + "\n"
      }
  }
  var=File.basename(incl_file.name,".h")
  interface_file << %Q{%include "#{File.basename(incl_file.name)}"\n}
  write_file(%Q{#{output_dir}/#{var}.i},interface_file)
end

def run_swig(swig_dir, gen_dir)
  puts "swig_dir:           "+ swig_dir
  puts "gen_dir:           "+ gen_dir
  Dir.chdir(swig_dir+"/..")
  #swig -c++ -csharp -v -Wall -I./headers -I./output -I/usr/include -I/usr/include/c++/4.6.3 -debug-classes -namespace nogre -outdir ./output/gen mulaCircleSquare.i logger.i gatoPerroShape.i
  ifiles=Dir.entries(swig_dir).select{|entry| File.extname(entry)==".i"}  
  puts "Entries:      "+  Dir.entries(swig_dir).to_s
  puts "IFILES:           "+ ifiles.to_s
  include_dirs="-I../../headers -I/usr/include -I/usr/include/c++/4.6.3"  
  swig_opts="-c++ -csharp -v -Wall -debug-classes -namespace nogre -outdir #{gen_dir}" 
  ifiles.each{|f| 
    
    command=%Q{swig #{swig_opts} #{include_dirs} #{swig_dir}/#{f}}
    
    output=IO.popen(command)
    log(output.readlines.join)
  }    
end

def print_incl_files(incl_files)
incl_files.each { |f| 
    log "incl_file:" + f.name
    f.api_classes.each { |c|
        log "Api Class:" + c.name
        c.api_methods.each { |m|
          log "Api Method:" + m.name
        }
        c.ignored_methods.each { |m|
          log "Ignored Method:" + m.name
        }
    }
    f.ignored_classes.each { |c|
        log "Ignored Class:" + c.name
        c.methods.each { |m|
          log "Ignored Method:" + m.name
        }      
    }    
  }
end

def print_api_namespaces(api_namespaces)
  api_namespaces.each{ |api_ns|
    api_ns.api_classes.each{|c|
      puts c.name
      c.api_methods.each{|m|
        puts m.name
      }  
    }
  }
end


  






