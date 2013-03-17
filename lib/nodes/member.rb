class DoxyMember < DoxyNode
  
  attr_reader :location
  attr_reader :definition
  attr_reader :args
  
  def file
    DoxyFile.new(:name => @file, :dir => @dir)
  end
  
  def compute_attr
    if @node 
       @path=@dir
       aux= self.xpath("location")[0]
       @file=File.basename(aux["file"])
       @location=%Q{#{aux["file"]}:#{aux["line"]}}
       temp=self.xpath("definition")
       if temp == nil || temp.empty? || temp[0].child==nil
         @definition = ""
       else
         @definition = temp[0].child.content
       end
       temp = self.xpath("argsstring")
       if temp == nil || temp.empty? || temp[0].child==nil
         @args = ""
       else
         @args = temp[0].child.content
       end       
    else
       raise "No XML node was associated to this enum"
    end
  end
end