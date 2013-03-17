class DoxyStruct < DoxyCompound
  
  def members filter=nil, access="public"
    get_variables filter, access
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
     @path = %Q{#{@dir}/struct#{aux}.xml}   
  end
end