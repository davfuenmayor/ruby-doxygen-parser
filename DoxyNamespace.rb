class DoxyNamespace < DoxyNode
  include DoxyParser
  
  def get_classes filter
    lst=@node.xpath("/doxygen/compounddef/innerclass")
    if filter
      lst.select!{|n| filter.include(n.child)}
    end
    lst.map{|c| DoxyClass.new(:parent => self, :node => c, :name => c.child)}
  end
  
  def get_functions filter    
  end
  
  def get_typedefs filter    
  end
  
  def get_enums filter    
  end
  
  def parse 
    @doc = parse_namespace @path
  end  
end