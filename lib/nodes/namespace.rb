module Doxyparser

	# A C/C++ Namespace
  class Namespace < Compound

		# @return [Array<Function>] list of functions defined inside this namespace but outside any {Class} or {Struct} 
    def functions(filter=nil)
    	return @functions if @functions
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="func"]/memberdef[@kind="function"]})
      @functions = do_filter(filter, lst, Doxyparser::Function) { |node|
        node.xpath("name")[0].child.content.strip
      }
    end

		# @return [Array<Enum>] list of enums defined inside this namespace but outside any {Class} or {Struct}
    def enums(filter=nil)
    	return @enums if @enums 
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="enum"]/memberdef[@kind="enum"]})
      filter.map! { |exp| exp =~ /^#{@basename}_Enum/ ? /@\d*/ : exp } unless filter.nil?
      @enums = do_filter(filter, lst, Doxyparser::Enum) { |node|
        node.xpath("name")[0].child.content.strip
      }
    end

		# @return [Array<Variable>] list of variables defined inside this namespace but are not attributes of any {Class} or {Struct}
		  def variables(filter=nil)
    	return @variables if @variables
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="var"]/memberdef[@kind="variable"]})
      @variables = do_filter(filter, lst, Doxyparser::Variable) { |node|
        node.xpath("name")[0].child.content.strip
      }
    end

		# @return [Array<Typedef>] list of typedefs defined inside this namespace but outside any {Class} or {Struct}
    def typedefs(filter=nil)
    	return @typedefs if @typedefs
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="typedef"]/memberdef[@kind="typedef"]})
      @typedefs = do_filter(filter, lst, Doxyparser::Typedef) { |node| 
      	del_spaces(node.xpath("name")[0].child.content)
      }
    end
	
		# @return [Array<Namespace>] list of namespaces defined inside this one
    def innernamespaces(filter=nil)
    	return @innernamespaces if @innernamespaces
      lst = doc.xpath(%Q{/doxygen/compounddef/innernamespace})
      @innernamespaces = do_filter(filter, lst, Doxyparser::Namespace) { |node|
        del_spaces del_prefix_class(node.child.content)
      }
    end

		# @return [Array<Struct>] list of structs defined in this namespace
    def structs(filter=nil)
			return @structs if @structs
      lst = doc.xpath(%Q{/doxygen/compounddef/innerclass})
      lst = lst.select { |c| c["refid"].start_with?("struct") }
      @structs = do_filter(filter, lst, Doxyparser::Struct) { |node|
        del_spaces del_prefix_class(node.child.content)
      }
    end

		# @return [Array<Class>] list of classes defined in this namespace
    def classes(filter=nil)
    	return @classes if @classes
      lst = doc.xpath(%Q{/doxygen/compounddef/innerclass})
      lst = lst.select { |c| c["refid"].start_with?("class") }
      @classes = do_filter(filter, lst, Doxyparser::Class) { |node|
        del_spaces del_prefix_class(node.child.content)
      }
    end

	  # @return nil always 
    def file
      nil
    end

    private

    def compute_path
      aux = escape_class_name(@name)
      @xml_path = %Q{#{@dir}/namespace#{aux}.xml}
    end
  end
end