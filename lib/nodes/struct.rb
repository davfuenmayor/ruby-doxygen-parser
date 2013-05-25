module Doxyparser

	class Struct < Compound

		def file
			n=doc.xpath("/doxygen/compounddef/includes")[0]
			raise "#{self.name} #{self.class.name} does not have correctly generated documentation. Use 'EXTRACT_ALL' Doxygen flag" unless n
			HFile.new(dir: @dir, node: n)
		end

		def friends
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="friend"]/memberdef[@kind="friend"]})
			lst.map { |node|
				Doxyparser::Friend.new(parent: self, node: node)
			}
		end

		def template_params
			params=doc.xpath(%Q{/doxygen/compounddef/templateparamlist/param})
			params.map { |param|
				Doxyparser::Param.new(parent: self, node: param)
			}
		end

		def methods access=:public, static=nil, filter=nil
			if static.nil?
				static="-"
			else
				static="-static-"
			end
			sectiondef=%Q{#{access}#{static}func}
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="function"][@prot="#{access}"]})
			do_filter(filter, lst, Doxyparser::Function) { |node|
				node.xpath("name")[0].child.content
			}
		end

		def attributes access=:public, static=nil, filter=nil
			if static.nil?
				static="-"
			else
				static="-static-"
			end
			sectiondef=%Q{#{access}#{static}attrib}
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="variable"][@prot="#{access}"]})
			do_filter(filter, lst, Doxyparser::Variable) { |node|
				node.xpath("name")[0].child.content
			}
		end

		def innerclasses access=:public, filter=nil
			lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
			lst = lst.select { |c| c["refid"].start_with?("class") }
			do_filter(filter, lst, Doxyparser::Class) { |node|
				del_prefix(node.child.content)
			}
		end

		def innerstructs access=:public, filter=nil
			lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
			lst = lst.select { |c| c["refid"].start_with?("struct") }
			do_filter(filter, lst, Doxyparser::Struct) { |node|
				del_prefix(node.child.content)
			}
		end

		def innerenums access=:public, filter=nil
			sectiondef=%Q{#{access}-type}
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="enum"][@prot="#{access}"]})
			filter.map!{ |exp| exp =~ /^_Enum/ ? /@\d*/ : exp} unless filter.nil?
			do_filter(filter, lst, Doxyparser::Enum) { |node|
				node.xpath("name")[0].child.content
			}
		end

		def typedefs access=:public, filter=nil
			sectiondef=%Q{#{access}-type}
			lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="typedef"][@prot="#{access}"]})
			do_filter(filter, lst, Doxyparser::Typedef) { |node| del_spaces node.xpath("name")[0].child.content }
		end

		private

		def compute_path
			aux = escape_class_name @name
			@xml_path = %Q{#{@dir}/struct#{aux}.xml}
		end
	end
end