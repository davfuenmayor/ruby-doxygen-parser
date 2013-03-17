class DoxyClass < DoxyCompound
    
      
  def methods filter=nil, access="public", static=nil
    if static==nil
      static="-"
    else
      static="-static-"
    end
    sectiondef=%Q{#{access}#{static}func}
    get_functions filter, sectiondef, access
  end
  
  def attributes filter=nil, access="public", static=nil
    if static==nil
      static="-"
    else
      static="-static-"
    end
    sectiondef=%Q{#{access}#{static}attrib}
    get_variables filter, sectiondef, access    
  end
  
  def innerclasses filter=nil, access="public"
    get_classes filter, access
  end
  
  def innerstructs filter=nil, access="public"
    get_structs filter, access
  end
  
  def innerenums filter=nil, access="public"
    sectiondef=%Q{#{access}-type}
    get_enums filter, sectiondef, access
  end
  
  def typedefs
    get_typedefs
  end
  
  private
  
  def compute_path
     aux=%Q{#{@name}}.gsub("::","_1_1")
     @path = %Q{#{@dir}/class#{aux}.xml}   
  end 
  
end