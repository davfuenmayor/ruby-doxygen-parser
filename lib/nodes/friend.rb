module Doxyparser

	class Friend < Member

		def is_class?
			args.nil? || args == ""
		end

		def is_qualified?
			basename.include? '::'
		end
		
		private 
		
		def find_name
			@basename = @node.xpath("name")[0].child.content
			@parent.name + '::' + @basename
		end
	end
end