module Doxyparser

  class Namespace < Compound

    def functions(filter=nil)
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="func"]/memberdef[@kind="function"]})
      do_filter(filter, lst, Doxyparser::Function) { |node|
        node.xpath("name")[0].child.content.strip
      }
    end

    def enums(filter=nil)
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="enum"]/memberdef[@kind="enum"]})
      filter.map! { |exp| exp =~ /^#{@basename}_Enum/ ? /@\d*/ : exp } unless filter.nil?
      do_filter(filter, lst, Doxyparser::Enum) { |node|
        node.xpath("name")[0].child.content.strip
      }
    end

    def variables(filter=nil)
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="var"]/memberdef[@kind="variable"]})
      do_filter(filter, lst, Doxyparser::Variable) { |node|
        node.xpath("name")[0].child.content.strip
      }
    end

    def typedefs(filter=nil)
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="typedef"]/memberdef[@kind="typedef"]})
      do_filter(filter, lst, Doxyparser::Typedef) { |node| 
      	del_spaces(node.xpath("name")[0].child.content)
      }
    end

    def innernamespaces(filter=nil)
      lst = doc.xpath(%Q{/doxygen/compounddef/innernamespace})
      do_filter(filter, lst, Doxyparser::Namespace) { |node|
        del_spaces del_prefix_class(node.child.content)
      }
    end

    def structs(filter=nil)
      lst = doc.xpath(%Q{/doxygen/compounddef/innerclass})
      lst = lst.select { |c| c["refid"].start_with?("struct") }
      do_filter(filter, lst, Doxyparser::Struct) { |node|
        del_spaces del_prefix_class(node.child.content)
      }
    end

    def classes(filter=nil)
      lst = doc.xpath(%Q{/doxygen/compounddef/innerclass})
      lst = lst.select { |c| c["refid"].start_with?("class") }
      do_filter(filter, lst, Doxyparser::Class) { |node|
        del_spaces del_prefix_class(node.child.content)
      }
    end

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