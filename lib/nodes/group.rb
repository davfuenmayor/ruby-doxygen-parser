class DoxyGroup < DoxyCompound
    
  
  
  def classes filter=nil, access="public"
    lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
    lst = lst.select{|c| c["refid"].start_with?("class")}
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{ |node| 
        filter.include? del_spaces(node.child.content)
      }
    end
    filtered_lst.map{|c| DoxyClass.new(:dir => @dir,:name => del_spaces(c.child.content))}    
  end 
    
 private
  
  def compute_path
     @path = %Q{#{@dir}/group__#{@name}.xml}   
  end
end