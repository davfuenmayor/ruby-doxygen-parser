module Doxyparser

	class Param < Node

		attr_reader :type
		attr_reader :declname
		attr_reader :value

		def compute_attr
			type_temp = @node.xpath("type")
			return if type_temp.nil? || type_temp.empty?
			@type = Type.new node: type_temp[0], parent: @parent, name: type_temp[0].content
			@name = @type.name
			

			declname_temp = @node.xpath("declname")
			return if declname_temp.nil? || declname_temp.empty?
			@declname = declname_temp[0].content
			
			@name += @declname

			value_temp = @node.xpath("defval")
			return if value_temp.nil? || value_temp.empty?
			@value = value_temp[0].content
		end
	end
end