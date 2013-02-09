class DoxyGroup < DoxyCompound
    
  def classes filter=nil, access="public"
    get_classes filter, access
  end
    
 private
  
  def compute_path
     @path = %Q{#{@dir}/group__#{@name}.xml}   
  end
end