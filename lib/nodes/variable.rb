class DoxyVariable < DoxyNode
   def compute_attr
    if @node 
       aux= self.xpath("location")[0]
       @path=%Q{#{aux["file"]}:#{aux["line"]}}
    else
       raise "No XML node was associated to this variable"
    end
  end
end