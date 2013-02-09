class DoxyCompound < DoxyNode
  
  private
        
  def compute_attr
    if @node 
       @path = %Q{#{@dir}/#{self.refid}.xml}
    else
       compute_path
    end
  end
  
end