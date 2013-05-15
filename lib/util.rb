module Doxyparser

  module Util

    def del_spaces n
      #nm.gsub(/.*::/i,"").gsub(/\s*/i,"")
      n.gsub(/\s*/i, "")
    end

    def del_prefix n
      n.gsub(/.*::/i, "")
    end

    def escape_file_name filename
      if filename.include? '_8'
        return filename.gsub('_8', '.')
      else
        return filename.gsub('.', '_8')
      end
    end

    def escape_class_name filename
      if filename.include? '_1_1'
        return filename.include? '_1_1'
      else
        return filename.gsub('::','_1_1')
      end
    end

    def read_file file_name
      file = File.open(file_name, "r")
      data = file.read
      file.close
      return data
    end

    def write_file file_name, data
      file = File.open(file_name, "w")
      count = file.write(data)
      file.close
      return count
    end

    def do_filter filter, lst, clazz
      if filter
		  filtered_lst = []
        filter.each { |val|
        			found = lst.select { |node|  val == yield(node) }
         	 raise "The object: #{val} #{clazz} could not be found while parsing" if found.nil? || found.empty?
         	 filtered_lst.push(*found) 
        }
      else
        	filtered_lst=lst
      end
      filtered_lst.map { |node| clazz.new(parent: self, node: node, name: yield(node)) }
    end
  end
end