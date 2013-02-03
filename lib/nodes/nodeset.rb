class DoxyNodeSet
  include DoxyParser 
 
  def method_missing sym, *args
    if @nodeSet.respond_to? sym
       @nodeSet.send(sym,*args)
    else
       super
    end     
  end
  
  def initialize nset
    @nodeSet = nset
  end  
end