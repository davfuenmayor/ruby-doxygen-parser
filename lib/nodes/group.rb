class DoxyGroup < DoxyNode
  
  def get_classes filter
    
  end
    
  def parse
    @doc = parse_group @path
  end 
end