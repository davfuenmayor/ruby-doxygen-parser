class DoxyMember < DoxyNode
  
  attr_reader :location
  
  def file
    DoxyFile.new(:name => @file.gsub(".","_8"), :dir => @dir)
  end
  
  def compute_attr
    if @node 
       @path=@dir
       aux= self.xpath("location")[0]
       @file=File.basename(aux["file"])
       @location=%Q{#{aux["file"]}:#{aux["line"]}}
    else
       raise "No XML node was associated to this enum"
    end
  end
end