module Doxyparser

	class Type < Node
		
		def nested_local_types
			refs = @node.xpath("ref")
			return [] if refs.nil? || refs.empty?
			refs.map { |r| Type.new(node: r, dir: @dir) }
		end
		
		def nested_typenames
			splitted = @name.split(%r{[<,>]}).map{|s| s.strip}.reject!{|s| s.nil? || !(s =~ /^\D[\w:]*\w$/)}
		end
		
		def template?
			@name.include? '<'
		end
		
		private

		def init_attributes
			@basename = @name
		end
		
		def find_name
    		@node.content
    	end
	end
end