module Doxyparser

  class HFile < Compound
  	
  	def compute_attr
  		super
  	end
    
    def list_included
    	lst=doc.xpath(%Q{/doxygen/compounddef/includes})      
      lst.map { |f| f.child.content }
    end
    
    def list_including
      lst=doc.xpath(%Q{/doxygen/compounddef/includedby})      
      lst.map { |f| f.child.content }
    end
    
    def files_included
      lst=doc.xpath(%Q{/doxygen/compounddef/includes[@local="yes"]})      
      lst.map { |f| Doxyparser::HFile.new(dir: @dir, name: f.child.content) }      
    end
    
    def files_including
      lst=doc.xpath(%Q{/doxygen/compounddef/includedby[@local="yes"]})
      lst.map { |f| Doxyparser::HFile.new(dir: @dir, name: f.child.content) }  
    end

    def structs
      lst=doc.xpath(%Q{/doxygen/compounddef/innerclass})
      lst = lst.select { |c| c["refid"].start_with?("struct") }
      lst.map { |node| Doxyparser::Struct.new(dir: @dir, name: del_spaces(node.child.content)) }
    end
    
    def classes
    	 lst=doc.xpath(%Q{/doxygen/compounddef/innerclass})
       lst = lst.select { |c| c["refid"].start_with?("class") }
       lst.map { |node| Doxyparser::Class.new(dir: @dir, name: del_spaces(node.child.content)) }
    end 

    def namespaces
      lst=doc.xpath(%Q{/doxygen/compounddef/innernamespace})
      lst.map { |node| Doxyparser::Namespace.new(dir: @dir, name: del_spaces(node.child.content)) }
    end

    def functions
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="func"]/memberdef[@kind="function"]})
      lst.map { |node| Doxyparser::Function.new(parent: self, node: node, name: del_spaces(node.xpath('name')[0].child.content)) }
    end

    def variables
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="var"]/memberdef[@kind="variable"]})
      lst.map { |node| Doxyparser::Variable.new(parent: self, node: node, name: del_spaces(node.xpath('name')[0].child.content)) }
    end

    def enums
    	lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="enum"]/memberdef[@kind="enum"]})
      lst.map { |node| Doxyparser::Enum.new(parent: self, node: node, name: del_spaces(node.xpath('name')[0].child.content)) }
    end

    def typedefs
    	lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="typedef"]/memberdef[@kind="typedef"]})
      lst.map { |node| Doxyparser::Typedef.new(parent: self, node: node, name: del_spaces(node.xpath('name')[0].child.content)) }
    end

    private

    def compute_path
      aux=%Q{#{@name}}.gsub(".", "_8")
      @xml_path = %Q{#{@dir}/#{aux}.xml}
    end
  end
end