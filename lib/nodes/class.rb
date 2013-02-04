class DoxyClass < DoxyNode
    
  def get_file
    n=@doc.xpath("/doxygen/compounddef/includes")[0]
    DoxyFile.new(:parent => self, :node => n, :name => escape_file_name(n.child.content))
  end
  
  def get_classes filter
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
  
  def get_functions filter=nil, access="public", static=nil
    if static==nil
      static="-"
    else
      static="-static-"
    end
    sectiondef=%Q{#{access}#{static}func}
    lst=@doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="function"][@prot="#{access}"]})
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{ |n| 
        node_text=n.xpath("name")[0].child.content 
        filter.include? node_text  # TODO: Implement filters with classes, to allow for more refined filtering of methods by signature
      }
    end
    filtered_lst.map{|c| DoxyFunction.new(:parent => self, :node => c, :name => c.xpath("name")[0].child.content)} 
  end
  
  def get_typedefs filter    
  end
  
  def get_enums filter, access="public"
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
    
  def compute_attr
    if @node 
       @path = %Q{#{@dir}/#{self.refid}.xml}
    else
       aux=%Q{#{@name}}.gsub("::","_1_1")
       @path = %Q{#{@dir}/class#{aux}.xml} 
    end
  end 
end