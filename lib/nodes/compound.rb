module Doxyparser

	class Compound < Node

		attr_reader :xml_path

		def new_unnamed
			@unnamed += 1
		end
		
		private

		def init_attributes
			super
			@unnamed = 0
			if @node
				@xml_path = %Q{#{@dir}/#{self.refid}.xml}
			else
				compute_path
			end
		end

		def find_name
			@node.child.content
		end

		def doc
			if @doc.nil?
				parse
			end
			@doc
		end

		def parse
			raise "No file found at this location: #{@xml_path} for node #{self.class.name} #{@name}" unless File.exists? @xml_path
			File.open(@xml_path) { |xml_doc|
				@doc=Nokogiri::XML(xml_doc)
			}
			self
		end
	end
end