class DoxyClass < DoxyCompound
    
  def basename
    name.gsub(/.*::/i,"").gsub(/\s*/i,"")
  end
    
  def methods filter=nil, access="public", static=nil
    if static==nil
      static="-"
    else
      static="-static-"
    end
    sectiondef=%Q{#{access}#{static}func}
    get_functions filter, sectiondef, access
  end
  
  def innerclasses filter=nil, access="public"
    get_classes filter, access
  end
  
  def attributes filter=nil, access="public", static=nil
    get_variables filter, access, static
  end
  
  def file
    get_file
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