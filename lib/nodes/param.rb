module Doxyparser

	# Each of the input parameters of a {Function}
	class Param < Node

		# Type of parameter
		attr_reader :type
		# Declared name of parameter
		attr_reader :declname
		# Default value of parameter
		attr_reader :value
		
		private
		
		def find_name
    		'param' # Default name if nothing else
    	end

		def init_attributes
			type_temp = @node.xpath("type")
			return if type_temp.nil? || type_temp.empty?
			@type = Type.new(node: type_temp[0], parent: @parent)
			@name = @type.name			

			declname_temp = @node.xpath("declname")
			return if declname_temp.nil? || declname_temp.empty?
			@declname = declname_temp[0].content			
			@name += @declname			
			@basename = @declname

			value_temp = @node.xpath("defval")
			return if value_temp.nil? || value_temp.empty?
			@value = value_temp[0].content
		end
	end
end