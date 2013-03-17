module DoxyParser
  
  private
  
  def del_spaces n
    #nm.gsub(/.*::/i,"").gsub(/\s*/i,"")
    n.gsub(/\s*/i,"")
  end
  
  def del_prefix n
    n.gsub(/.*::/i,"")
  end
  
  def escape_file_name filename 
    filename.gsub("_8",".")
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
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{ |n| 
        node_text = yield n
        filter.include? node_text  # TODO: Implement filters with classes, to allow for more refined filtering of methods by signature
      }
    end
    filtered_lst.map{|c| clazz.new(:parent => self, :node => c, :name => yield(c))} 
  end 
   
  protected
       
  def get_classes filter=nil, access="public"
    lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
    lst = lst.select{|c| c["refid"].start_with?("class")}
    do_filter(filter, lst, DoxyClass) { |node|
      del_spaces del_prefix(node.child.content)
    }      
  end
  
  def get_enums filter, sectiondef, access="public"
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="enum"][@prot="#{access}"]})
      do_filter(filter, lst, DoxyEnum) { |node|
        del_spaces node.xpath("name")[0].child.content 
      }    
  end
  
  def get_structs filter=nil, access="public"
    lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
    lst = lst.select{|c| c["refid"].start_with?("struct")}
    do_filter(filter, lst, DoxyStruct) { |node|
      del_spaces del_prefix(node.child.content)
    }      
  end 
  
  def get_namespaces filter=nil
    lst=doc.xpath(%Q{/doxygen/compounddef/innernamespace})
    do_filter(filter, lst, DoxyNamespace) { |node|
      del_spaces del_prefix(node.child.content)
    }      
  end     
  
  def get_functions filter, sectiondef, access="public"
    lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="function"][@prot="#{access}"]})
    do_filter(filter, lst, DoxyFunction) { |node|
      del_spaces node.xpath("name")[0].child.content 
    }
  end
  
  def get_variables filter, sectiondef, access="public"    
    lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="variable"][@prot="#{access}"]})
    do_filter(filter, lst, DoxyVariable) { |node|
      del_spaces node.xpath("name")[0].child.content 
    }
  end
  
  def get_file
    n=doc.xpath("/doxygen/compounddef/includes")[0]
    raise DoxyException::bad_doc(self.class.name, self.name) unless not n.nil? 
    DoxyFile.new(:dir => @dir, :name => escape_file_name(n.child.content))
  end
  
  def get_typedefs filter    
  end 
   
end