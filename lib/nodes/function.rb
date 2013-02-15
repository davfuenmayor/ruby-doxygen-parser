class DoxyFunction < DoxyMember
  
  attr_reader :params
  
  def file
    aux=%Q{#{@name}}.gsub(".","_8")
    DoxyFile.new name, dir
  end
  
  def constructor?
    name==parent.name.gsub(/.*::/i,"")
  end
  
  def destructor?
    name.start_with? %Q{~}
  end
  
  def compute_attr
    super
    @params=[]
    all_params= self.xpath("param")
    if all_params == nil || all_params.empty? || all_params[0].child==nil
        return
    end    
    all_params.each { |param|
      temp = ""      
      param.xpath("type//text()").each {|n| temp << n.content }
      @params << temp      
    }
      
  end
      
 
end