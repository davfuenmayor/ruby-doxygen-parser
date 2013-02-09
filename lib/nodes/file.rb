class DoxyFile < DoxyCompound 
  
  def classes filter=nil, access="public"
    get_classes filter, access
  end
  
  def typedefs
    # TODO
  end
  
  def functions filter=nil, access="public"
    # TODO
  end
  
  def structs filter=nil, access="public"
    # TODO
  end
  
  def enums filter=nil, access="public"
    # TODO
  end
    
  private
  
  def compute_path
     aux=%Q{#{@name}}.gsub(".","_8")
     @path = %Q{#{@dir}/#{aux}.xml}   
  end
end