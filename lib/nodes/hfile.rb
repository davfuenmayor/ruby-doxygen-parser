module Doxyparser

	# Representation of a C/C++ header file
  class HFile < Compound

	  # @return [Array<String>] names for all header files which are listed as include statements in this header file
    def list_included
      @list_included ||= doc.xpath(%Q{/doxygen/compounddef/includes}).map { |f| f.child.content }
    end
    
		# @return [Array<HFile>] local header files which are listed as include statements in this header file
    def files_included
      @files_included ||= doc.xpath(%Q{/doxygen/compounddef/includes[@local="yes"]}).map { |f| 	Doxyparser::HFile.new(dir: @dir, node: f) }
    end

		# @return [Array<String>] names for all header files which refer to this one in their include statements
    def list_including
      @list_including ||= doc.xpath(%Q{/doxygen/compounddef/includedby}).map { |f| f[:refid].nil? ? f.child.content : escape_file_name(f[:refid]) }
    end

	 	# @return [Array<HFile>] local header files which refer to this one in their include statements
    def files_including
      @files_including ||= doc.xpath(%Q{/doxygen/compounddef/includedby[@local="yes"]}).map { |f| Doxyparser::HFile.new(dir: @dir, node: f) }
    end
	
		# @return [Array<Struct>] structs declared inside this header file
    def structs
      @structs ||= doc.xpath(%Q{/doxygen/compounddef/innerclass}).select { |c| c["refid"].start_with?("struct") }.map { |node| Doxyparser::Struct.new(dir: @dir, node: node) }
    end

		# @return [Array<Class>] classes declared inside this header file
    def classes
      @classes ||= doc.xpath(%Q{/doxygen/compounddef/innerclass}).select { |c| c["refid"].start_with?("class") }.map { |node| Doxyparser::Class.new(dir: @dir, node: node) }
    end
		
		# @return [Array<Namespace>] namespaces declared inside this header file
    def namespaces
      @namespaces ||= doc.xpath(%Q{/doxygen/compounddef/innernamespace}).map { |node| Doxyparser::Namespace.new(dir: @dir, node: node) }
    end
	
	  # @return [Array<Function>] functions declared inside this header file	
    def functions
      @functions ||= doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="func"]/memberdef[@kind="function"]}).map { |node| Doxyparser::Function.new(parent: self, node: node) }
    end
		
		# @return [Array<Variable>] variables declared inside this header file
    def variables
      @variables ||= doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="var"]/memberdef[@kind="variable"]}).map { |node| Doxyparser::Variable.new(parent: self, node: node) }
    end
		
		# @return [Array<Enum>] enums declared inside this header file
    def enums
      @enums ||= doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="enum"]/memberdef[@kind="enum"]}).map { |node| Doxyparser::Enum.new(parent: self, node: node) }
    end

		# @return [Array<Typedef>] typedefs declared inside this header file
    def typedefs
      @typedefs ||= doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="typedef"]/memberdef[@kind="typedef"]}).map { |node| Doxyparser::Typedef.new(parent: self, node: node) }
    end

    private

    def find_name
    	if @node['refid'].nil?
    		@node.child.content
    	else
      	escape_file_name(self.refid)
    	end
    end
    
    def del_prefix_for(str)
      del_prefix_file(str)
    end

    def compute_path
      aux= escape_file_name(@name)
      @xml_path = %Q{#{@dir}/#{aux}.xml}
    end
  end
end