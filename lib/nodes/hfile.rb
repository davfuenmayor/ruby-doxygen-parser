module Doxyparser

  class HFile < Compound

    def list_included
      @list_included ||= doc.xpath(%Q{/doxygen/compounddef/includes}).map { |f| f.child.content }
    end

    def list_including
      @list_including ||= doc.xpath(%Q{/doxygen/compounddef/includedby}).map { |f| f[:refid].nil? ? f.child.content : escape_file_name(f[:refid]) }
    end

    def files_included
      @files_included ||= doc.xpath(%Q{/doxygen/compounddef/includes[@local="yes"]}).map { |f| 	Doxyparser::HFile.new(dir: @dir, node: f) }
    end

    def files_including
      @files_including ||= doc.xpath(%Q{/doxygen/compounddef/includedby[@local="yes"]}).map { |f| Doxyparser::HFile.new(dir: @dir, node: f) }
    end

    def structs
      @structs ||= doc.xpath(%Q{/doxygen/compounddef/innerclass}).select { |c| c["refid"].start_with?("struct") }.map { |node| Doxyparser::Struct.new(dir: @dir, node: node) }
    end

    def classes
      @classes ||= doc.xpath(%Q{/doxygen/compounddef/innerclass}).select { |c| c["refid"].start_with?("class") }.map { |node| Doxyparser::Class.new(dir: @dir, node: node) }
    end

    def namespaces
      @namespaces ||= doc.xpath(%Q{/doxygen/compounddef/innernamespace}).map { |node| Doxyparser::Namespace.new(dir: @dir, node: node) }
    end

    def functions
      @functions ||= doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="func"]/memberdef[@kind="function"]}).map { |node| Doxyparser::Function.new(parent: self, node: node) }
    end

    def variables
      @variables ||= doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="var"]/memberdef[@kind="variable"]}).map { |node| Doxyparser::Variable.new(parent: self, node: node) }
    end

    def enums
      @enums ||= doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="enum"]/memberdef[@kind="enum"]}).map { |node| Doxyparser::Enum.new(parent: self, node: node) }
    end

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