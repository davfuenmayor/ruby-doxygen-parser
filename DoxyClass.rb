class DoxyClass < DoxyNode
  include DoxyParser
  
  def get_classes filter
    
  end
  
  def get_functions filter    
  end
  
  def get_typedefs filter    
  end
  
  def get_enums filter    
  end
  
  def parse 
    @doc = parse_class @path
  end 
end