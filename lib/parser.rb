module DoxyParser
  
  private
  
  def escape_class_name classname 
    #classname.gsub(/.*::/i,"").gsub(/\s*/i,"")
    classname.gsub(/\s*/i,"")
  end
  
  def escape_file_name filename 
    filename.gsub("_8",".")
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
  
  protected
   
  def get_enums filter=nil, access="public"
      lst=@doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="enum"]/memberdef[@kind="enum"][@prot="#{access}"]})
      do_filter(filter, lst, DoxyEnum) { |node|
        node.xpath("name")[0].child.content 
      }    
    end
    
  def get_classes filter=nil, access="public"
    lst=@doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
    do_filter(filter, lst, DoxyClass) { |node|
      escape_class_name(node.child.content)
    }      
  end    
  
  def get_functions filter, sectiondef, access
    lst=@doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="function"][@prot="#{access}"]})
    do_filter(filter, lst, DoxyFunction) { |node|
      node.xpath("name")[0].child.content 
    }
  end
  
  def get_variables filter=nil, access="public", static=nil
    if static==nil
      static="-"
    else
      static="-static-"
    end
    sectiondef=%Q{#{access}#{static}attrib}
    lst=@doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="variable"][@prot="#{access}"]})
    do_filter(filter, lst, DoxyVariable) { |node|
      node.xpath("name")[0].child.content 
    }
  end
  
  def get_file
    n=@doc.xpath("/doxygen/compounddef/includes")[0]
    DoxyFile.new(:dir => @dir, :name => escape_file_name(n.child.content))
  end
  
  def get_typedefs filter    
  end 
   
end