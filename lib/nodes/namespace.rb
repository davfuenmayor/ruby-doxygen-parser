class DoxyNamespace < DoxyCompound
   
  def functions filter=nil, access="public"
    sectiondef = "func"
    get_functions filter, sectiondef, access    
  end
  
  def classes filter=nil, access="public"
    get_classes filter, access
  end
  
  def typedefs
    get_typedefs
  end
  
  def structs
    # TODO
  end
  
  def enums filter=nil, access="public"
    get_enums filter, access
  end
    
  private
  
  def compute_path    
       @path = %Q{#{@dir}/namespace#{@name}.xml}    
  end
end