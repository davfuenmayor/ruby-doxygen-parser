module Doxyparser

  class Type < Node

    attr_reader :name
    
    
    def is_template?
      name =~ /<\S+>/
    end
    
    def template_types
    	if is_template?
    		refs = @node.xpath("ref")
    		return if refs.nil? || refs.empty?
    		refs.each { |r|
    			@template_types << Type.new(node: r, name: r.content) 
    		}
    	end
    end
    
    def struct
      temp = n.xpath("type")
      return "" if temp.nil? || temp.empty? || temp[0].child==nil
      temp_ref = temp[0].xpath("ref")
      type = temp[0].content
    end
  end
end