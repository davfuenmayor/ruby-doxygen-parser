class DoxyEnum < DoxyNode
   def compute_attr
    if @node 
       aux= self.xpath("location")[0]
       @path=%Q{#{aux["file"]}:#{aux["line"]}}
    else
       raise "No XML node was associated to this enum"
    end
  end
end