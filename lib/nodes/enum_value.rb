module Doxyparser

  class EnumValue < Node
  	
		attr_reader :initializer
		
		def find_name
			@parent.name + '::' + @node.xpath("name")[0].child.content
		end
		
		def init_attributes
      super
      aux_initializer = @node.xpath("initializer")
      @initializer = aux_initializer[0].child.content.strip unless (aux_initializer.nil? || aux_initializer.empty?)
    end
  end
 end
