class DoxyNamespace < DoxyNode
   
  def get_classes filter=nil
    lst=@doc.xpath("/doxygen/compounddef/innerclass")
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{|n|
        node_text=escape_class_name n.child.content 
        filter.include? node_text
      }
    end
    filtered_lst.map{|c| DoxyClass.new(:parent => self, :node => c, :name => escape_class_name(c.child.content))}
  end
  
  def get_functions filter=nil, access="public"
    lst=@doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="func"]/memberdef[@kind="function"][@prot="#{access}"]})
    filtered_lst=lst  
    
    if filter
      filtered_lst=lst.select{ |n| 
        node_text=n.xpath("name")[0].child.content 
        filter.include? node_text  # TODO: Implement filters with classes, to allow for more refined filtering of methods by signature
      }
    end
    puts filtered_lst.size
    filtered_lst.map{|c| DoxyFunction.new(:parent => self, :node => c, :name => c.xpath("name")[0].child.content)}
  end
 
  def get_enums filter=nil, access="public"
    lst=@doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="enum"]/memberdef[@kind="enum"][@prot="#{access}"]})
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{ |n| 
        node_text=n.xpath("name")[0].child.content 
        filter.include? node_text
      }
    end
    filtered_lst.map{|c| DoxyEnum.new(:parent => self, :node => c, :name => c.xpath("name")[0].child.content)} 
  end
  
   
  def get_typedefs filter=nil
    #lst=@doc.xpath(%Q{/doxygen/compounddef/sectiondef/memberdef[@kind="typedef"]})    
  end
  
  def compute_attr
    if @node 
       @path = %Q{#{@dir}/#{self.refid}.xml}
    else
       @path = %Q{#{@dir}/namespace#{@name}.xml} 
    end
  end
end