class DoxyNode
  #include DoxyParser
  
  attr_accessor :dir
  attr_accessor :name
  attr_accessor :node
  attr_accessor :parent
  attr_accessor :doc
  attr_accessor :path
 
  def method_missing sym, *args
    raise "This object has not yet been associated to an xml file using parse() method" unless @doc  
    if @doc.respond_to? sym
       @doc.send(sym,*args)
    else
      @doc[sym.to_s] || super  
    end     
  end
  
  def initialize hash
    @doc = nil
    @path = nil 
    # If an explicit name is given it takes precedence  
    if hash[:name]
      @name = hash[:name]      
    end
    # If an explicit directory is given it takes precedence  
    if hash[:dir]
      @dir = hash[:dir]      
    end
    # If a reference to an xml declaration (node) is given
    if hash[:node]
      # A parent must also be given      
      if hash[:parent]
        @parent = hash[:parent]
        @dir ||= parent.dir # Only if @dir is nil
      else
        raise "Node was defined but no parent was found"
      end
      # Default name if a node is given
      @name ||= hash[:node].first_element_child.child
      @path = %Q{#{@dir}/#{hash[:node].refid}.xml}
    else      
      @path = %Q{#{@dir}/namespace#{@name}.xml}    
    end  
  end  
end