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
  
  def get_functions filter    
  end
  
  def get_typedefs filter    
  end
  
  def get_enums filter    
  end
  
  def parse 
    @doc = parse_namespace @path
    self
  end  
end