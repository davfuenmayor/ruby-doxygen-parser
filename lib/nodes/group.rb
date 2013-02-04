class DoxyGroup < DoxyNode
  
    def get_classes filter=nil
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
       @path = %Q{#{@dir}/group__#{@name}.xml} 
    end
  end
end