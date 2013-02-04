class DoxyFile < DoxyNode
  
  def get_classes filter
    lst=@doc.xpath("/doxygen/compounddef/innerclass")
    filtered_lst=lst
    if filter
      filtered_lst=lst.select{|n|
        node_text=escape_class_name n.child.content 
        filter.include? node_text
      }
    end
    filtered_lst.map{|c| DoxyClass.new(:parent => self, :node => c, :name => escape_class_name(c.child.content))}
  end
  
   def compute_attr
    if @node
       @path = %Q{#{@dir}/#{self.refid}.xml}
    else
       aux=%Q{#{@name}}.gsub(".","_8")
       @path = %Q{#{@dir}/#{aux}.xml} 
    end
  end 
end