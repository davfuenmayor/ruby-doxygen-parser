module Doxyparser

  module Util

    def self.home_dir
      File.expand_path('..', File.dirname(__FILE__))
    end

    def del_spaces(n)
      n.gsub(/\s+/, "")
    end
    
    def escape_all(typename)
    	return del_prefix_class(escape_template(escape_const_ref_ptr(typename)))
    end
    
    def escape_template(typename)
      typename.gsub(/<.+$/,'').strip
    end
    
    def escape_const_ref_ptr(typename)
      typename.gsub(/^ *const /,'').gsub(/ +(const)* *[&*]* *(const)* *$/,'').strip
    end
    
    def self.escape_const_ref_ptr(typename)
      typename.gsub(/^ *const /,'').gsub(/ +(const)* *[&*]* *(const)* *$/,'').strip
    end
    
    def del_prefix_class(n) # Previuously escaped for const
	     n.gsub(%r{^[^<]*[:]}, "")
    end
    
    def del_prefix_file(n)
	     n.gsub(%r{/$}, "")
	     n.gsub(%r{.*[/]}, "")
    end

    def escape_file_name(filename)
      if filename =~ %r{[\./]}
        return filename.gsub('.', '_8').gsub('/', '_2')
      else
        return filename.gsub('_8', '.').gsub('_2', '/')
      end
    end

    def escape_class_name(filename)
      if filename.include? '::'
        return filename.gsub('::','_1_1')
      else
        return filename.gsub('_1_1','::')
      end
    end

    def self.read_file(file_name)
      file = File.open(file_name, "r")
      data = file.read
      file.close
      return data
    end

    def self.write_file(file_name, data)
      file = File.open(file_name, "w")
      count = file.write(data)
      file.close
      return count
    end

    def do_filter(filter, lst, clazz)
      if filter
        filtered_lst = []
        filter.each { |val|
          found = lst.select { |node| match(val, yield(node)) }
          raise "The object: #{val} #{clazz} could not be found while parsing" if found.nil? || found.empty?
          filtered_lst.push(*found)
        }
      else
      filtered_lst=lst
      end
      filtered_lst.map { |node| clazz.new(parent: self, node: node) }
    end

    def match(val, aux_name)
      if val.is_a?(Regexp)
      return aux_name =~ val
      else
      return aux_name == val
      end
    end
  end
end