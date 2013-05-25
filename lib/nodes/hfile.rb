module Doxyparser

	class HFile < Compound

		def list_included
			lst=doc.xpath(%Q{/doxygen/compounddef/includes})
			lst.map { |f| f.child.content }
		end

		def list_including
			lst=doc.xpath(%Q{/doxygen/compounddef/includedby})
			lst.map { |f| f[:refid].nil? ? f.child.content : escape_file_name(f[:refid]) }
		end

		def files_included
			lst=doc.xpath(%Q{/doxygen/compounddef/includes[@local="yes"]})
			lst.map { |f| Doxyparser::HFile.new(dir: @dir, node: f) }
		end

		def files_including
			lst=doc.xpath(%Q{/doxygen/compounddef/includedby[@local="yes"]})
			lst.map { |f| Doxyparser::HFile.new(dir: @dir, node: f) }
		end

		def structs
			lst=doc.xpath(%Q{/doxygen/compounddef/innerclass})
			lst = lst.select { |c| c["refid"].start_with?("struct") }
			lst.map { |node| Doxyparser::Struct.new(dir: @dir, node: node) }
		end

		def classes
			lst=doc.xpath(%Q{/doxygen/compounddef/innerclass})
			lst = lst.select { |c| c["refid"].start_with?("class") }
			lst.map { |node| Doxyparser::Class.new(dir: @dir, node: node) }
		end

		def namespaces
			lst=doc.xpath(%Q{/doxygen/compounddef/innernamespace})
			lst.map { |node| Doxyparser::Namespace.new(dir: @dir, node: node) }
		end

		def functions
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="func"]/memberdef[@kind="function"]})
			lst.map { |node| Doxyparser::Function.new(parent: self, node: node) }
		end

		def variables
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="var"]/memberdef[@kind="variable"]})
			lst.map { |node| Doxyparser::Variable.new(parent: self, node: node) }
		end

		def enums
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="enum"]/memberdef[@kind="enum"]})
			lst.map { |node| Doxyparser::Enum.new(parent: self, node: node) }
		end

		def typedefs
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="typedef"]/memberdef[@kind="typedef"]})
			lst.map { |node| Doxyparser::Typedef.new(parent: self, node: node) }
		end

		private
		
		def find_name
			escape_file_name self.refid
		end

		def compute_path
			aux= escape_file_name @name
			@xml_path = %Q{#{@dir}/#{aux}.xml}
		end
	end
end