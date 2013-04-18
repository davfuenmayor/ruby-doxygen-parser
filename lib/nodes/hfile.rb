module Doxyparser

  class HFile < Compound
    
    def includes local=true
      local = local ? 'yes' : 'no' 
      lst=doc.xpath(%Q{/doxygen/compounddef/includes[@local="#{local}"]})
      lst.map { |f| escape_file_name f['refid'] }
    end
    
    def included_by local=true
      local = local ? 'yes' : 'no' 
      lst=doc.xpath(%Q{/doxygen/compounddef/includedby[@local="#{local}"]})
      lst.map { |f| escape_file_name f['refid'] }
    end

    def classes access="public", filter=nil
      lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
      lst = lst.select { |c| c["refid"].start_with?("class") }
      filtered_lst=lst
      if filter
        filtered_lst=lst.select { |node|
          filter.include? del_spaces(node.child.content)
        }
      end
      filtered_lst.map { |c| Doxyparser::Class.new(:dir => @dir, :name => del_spaces(c.child.content)) }
    end

    def namespaces filter=nil
      lst=doc.xpath(%Q{/doxygen/compounddef/innernamespace})
      filtered_lst=lst
      if filter
        filtered_lst=lst.select { |node|
          filter.include? del_spaces(node.child.content)
        }
      end
      filtered_lst.map { |c| Doxyparser::Namespace.new(:dir => @dir, :name => del_spaces(c.child.content)) }
    end

    def structs access="public", filter=nil
      lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
      lst = lst.select { |c| c["refid"].start_with?("struct") }
      filtered_lst=lst
      if filter
        filtered_lst=lst.select { |node|
          filter.include? del_spaces(node.child.content)
        }
      end
      filtered_lst.map { |c| Doxyparser::Struct.new(:dir => @dir, :name => del_spaces(c.child.content)) }
    end

    def functions access="public", filter=nil
      sectiondef = "func"
      get_functions filter, sectiondef, access
    end

    def variables access="public", filter=nil
      sectiondef = "var"
      get_variables filter, sectiondef, access
    end

    def enums access="public", filter=nil
      get_enums filter, "enum", access
    end

    def typedefs
      # TODO
    end

    private

    def compute_path
      aux=%Q{#{@name}}.gsub(".", "_8")
      @path = %Q{#{@dir}/#{aux}.xml}
    end
  end
end