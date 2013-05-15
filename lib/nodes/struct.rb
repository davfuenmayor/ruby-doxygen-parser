module Doxyparser

  class Struct < Compound

    def friends      
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="friend"]/memberdef[@kind="friend"]})      
      lst.map { |node| 
        nodename = del_spaces node.xpath("name")[0].child.content
        Doxyparser::Friend.new(parent: self, node: node, name: nodename) 
      }
    end
    
    def template_params
    	lst=doc.xpath(%Q{/doxygen/compounddef/templateparamlist/param})
    	lst.map { |param| 
        Doxyparser::Param.new(parent: self, node: param, name: 'param') 
      }
    end
    
    def methods access=:public, static=nil, filter=nil
      if static.nil?
        static="-"
      else
        static="-static-"
      end
      sectiondef=%Q{#{access}#{static}func}
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="function"][@prot="#{access}"]})
      do_filter(filter, lst, Doxyparser::Function) { |node|
        del_spaces node.xpath("name")[0].child.content
      }
    end

    def attributes access=:public, static=nil, filter=nil
      if static.nil?
        static="-"
      else
        static="-static-"
      end
      sectiondef=%Q{#{access}#{static}attrib}
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="variable"][@prot="#{access}"]})
      do_filter(filter, lst, Doxyparser::Variable) { |node|
        del_spaces node.xpath("name")[0].child.content
      }
    end

    def innerclasses access=:public, filter=nil
    	lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
      lst = lst.select { |c| c["refid"].start_with?("class") }
      do_filter(filter, lst, Doxyparser::Class) { |node|
        del_spaces del_prefix(node.child.content)
      }
    end

    def innerstructs access=:public, filter=nil
    	lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
      lst = lst.select { |c| c["refid"].start_with?("struct") }
      do_filter(filter, lst, Doxyparser::Struct) { |node|
        del_spaces del_prefix(node.child.content)
      }
    end

    def innerenums access=:public, filter=nil
      sectiondef=%Q{#{access}-type}
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="enum"][@prot="#{access}"]})
      do_filter(filter, lst, Doxyparser::Enum) { |node|
        aux = node.xpath("name")[0].child.content
      	if aux.include? '@'
      		@number_unnamed += 1
      		aux = '_Enum' +  (@number_unnamed == 1 ? '' : @number_unnamed.to_s)
      	end
         aux.strip
      }
    end

    def typedefs access=:public, filter=nil
    	sectiondef=%Q{#{access}-type}
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="typedef"][@prot="#{access}"]})
      do_filter(filter, lst, Doxyparser::Typedef) { |node| del_spaces node.xpath("name")[0].child.content }
    end

    private

    def compute_path
      aux = escape_class_name @name
      @xml_path = %Q{#{@dir}/struct#{aux}.xml}
    end
  end
end