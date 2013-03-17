class DoxyFile < DoxyCompound 
  
  def classes filter=nil, access="public"
    lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
    lst = lst.select{|c| c["refid"].start_with?("class")}
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{ |node| 
        filter.include? del_spaces(node.child.content)
      }
    end
    filtered_lst.map{|c| DoxyClass.new(:dir => @dir,:name => del_spaces(c.child.content))}    
  end 
  
  def namespaces filter=nil
    lst=doc.xpath(%Q{/doxygen/compounddef/innernamespace})
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{ |node| 
        filter.include? del_spaces(node.child.content)
      }
    end
    filtered_lst.map{|c| DoxyNamespace.new(:dir => @dir,:name => del_spaces(c.child.content))} 
  end 
  
  def structs filter=nil, access="public"
    lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
    lst = lst.select{|c| c["refid"].start_with?("struct")}
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{ |node| 
        filter.include? del_spaces(node.child.content)
      }
    end
    filtered_lst.map{|c| DoxyStruct.new(:dir => @dir,:name => del_spaces(c.child.content))} 
  end   
  
  def functions filter=nil, access="public"
    sectiondef = "func"
    get_functions filter, sectiondef, access    
  end
  
  def variables filter=nil, access="public"
    sectiondef = "var"
    get_variables filter, sectiondef, access    
  end
  
  def enums filter=nil, access="public"
    get_enums filter, "enum", access
  end
  
  def typedefs
    # TODO
  end
    
  private
  
  def compute_path
     aux=%Q{#{@name}}.gsub(".","_8")
     @path = %Q{#{@dir}/#{aux}.xml}   
  end
end