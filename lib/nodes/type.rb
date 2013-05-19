module Doxyparser

	class Type < Node

		def template?
			@name.include? '<'
		end

		def compute_attr
			@name = @basename
		end

		def nested_local_types
			refs = @node.xpath("ref")
			return [] if refs.nil? || refs.empty?
			refs.map { |r| Type.new(parent: self, node: r, name: r.content) }
		end
		
		def nested_typenames
			splitted = @name.split(%r{[<,>]}).map{|s| s.strip}.reject!{|s| s.nil? || !(s =~ /^\D[\w:]*\w$/)}
		end
	end
end