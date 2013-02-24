class DoxyNamespace < DoxyCompound
   
  def functions filter=nil, access="public"
    sectiondef = "func"
    get_functions filter, sectiondef, access    
  end
  
  def classes filter=nil, access="public"
    get_classes filter, access
  end
  
  def innernamespaces filter=nil
    get_namespaces filter
  end
  
  def typedefs
    get_typedefs
  end
  
  def structs filter=nil, access="public"
    get_structs filter, access
  end
  
  def enums filter=nil, access="public"
    get_enums filter, "enum", access
  end
    
  private
  
  def compute_path    
       @path = %Q{#{@dir}/namespace#{@name}.xml}    
  end
end