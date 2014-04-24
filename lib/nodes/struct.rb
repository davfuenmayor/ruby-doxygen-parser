module Doxyparser

	# A plain old OOP Class 
  class Struct < Compound
  	
  	# @return [bool] true if any of its methods is 'pure virtual'
    def abstract?
    	@is_abstract ||= methods(:all).any? { |m| m.virt == 'pure-virtual'}
    end
    
    # @param access [Symbol] access modifier (:public, :protected, :private, :all) 
    # @return [Array<Function>] declared constructors
    def constructors(access = :public)
    	return case access
    	when :public
      	@public_constructors ||= methods(:public, nil, [@basename])
    	when :protected
      	@protected_constructors ||= methods(:protected, nil, [@basename])
    	when :private
      	@private_constructors ||= methods(:private, nil, [@basename])
    	when :all
    		constructors(:public) + constructors(:protected) + constructors(:private)
   		end
    end
    
    # @param access [Symbol] access modifier (:public, :protected, :private, :all) 
    # @return [Array<Function>] declared destructors
    def destructors(access = :public)
    	return case access
    	when :public
      	@public_destructors ||= methods(:public, nil, [/^~/])
    	when :protected
      	@protected_destructors ||= methods(:protected, nil, [/^~/])
    	when :private
      	@private_destructors ||= methods(:private, nil, [/^~/])
    	when :all
    		destructors(:public) + destructors(:protected) + destructors(:private)
   		end
    end
    
    # @param access [Symbol] access modifier (:public, :protected, :private, :all)
    # @param static If nil are static members excluded. If not nil only static members are returned
    # @param filter [Array<String>] list of Regex. Members whose name does not match any of the regexes will be excluded
    # @return [Array<Function>] declared methods
    def methods(access = :public, static = nil, filter = nil)
    	if access == :all
    		return methods(:public, static, filter) + methods(:protected, static, filter) + methods(:private, static, filter)
    	end
    	if access == :public && filter.nil? # Caches public methods
    	 	if static.nil?
    			@public_methods ||= _methods(:public, nil, nil)
    			return @public_methods
    		end
    		@public_static_methods ||= _methods(:public, true, nil)
    		return @public_static_methods
    	end
      _methods(access, static, filter)
    end

		# @param access [Symbol] access modifier (:public, :protected, :private, :all)
    # @param static If nil are static members excluded. If not nil only static members are returned
    # @param filter [Array<String>] list of Regex. Members whose name does not match any of the regexes will be excluded
    # @return [Array<Variable>] declared attributes
    def attributes(access = :public, static = nil, filter = nil)
    	if access == :all
    		return attributes(:public, static, filter) + attributes(:protected, static, filter) + attributes(:private, static, filter) 
    	end
    	if access == :public && filter.nil? # Caches public attributes
    	 	if static.nil?
    			@public_attributes ||= _attributes(:public, nil, nil)
    			return @public_attributes
    		end
  			@public_static_attributes ||= _attributes(:public, true, nil)
   			return @public_static_attributes
    	end
	    _attributes(access, static, filter)
    end
    
    # @param access [Symbol] access modifier (:public, :protected, :private, :all)
    # @param filter [Array<String>] list of Regex. Members whose name does not match any of the regexes will be excluded
    # @return [Array<Struct>] declared inner-classes and inner-structs
    def innerclasses(access = :public, filter = nil)
  		if filter.nil?
	    	if access == :all
    			@all_innerclasses ||= innerclasses(:public) + innerclasses(:protected) + innerclasses(:private)
    			return @all_innerclasses	
    		end
	    	if access == :public
  	  		@public_innerclasses ||= only_innerclasses(:public) + only_innerstructs(:public)
    			return @public_innerclasses
    		end
    	end
    	if access == :all
   			return innerclasses(:public, filter) + innerclasses(:protected, filter) + innerclasses(:private, filter)
   		end
    	only_innerclasses(access, filter) + only_innerstructs(access, filter)
    end

		# @param access [Symbol] access modifier (:public, :protected, :private, :all)
    # @param filter [Array<String>] list of Regex. Members whose name does not match any of the regexes will be excluded
    # @return [Array<Struct>] declared inner-classes (inner-structs are excluded)
    def only_innerclasses(access = :public, filter = nil)
    	if access == :all
    		return innerclasses(:public, filter) + innerclasses(:protected, filter) + innerclasses(:private, filter) 
    	end
      lst = doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
      lst = lst.select { |c| c["refid"].start_with?("class") }
      do_filter(filter, lst, Doxyparser::Class) { |node|
        del_prefix(node.child.content)
      }
    end

	  # @param access [Symbol] access modifier (:public, :protected, :private, :all)
    # @param filter [Array<String>] list of Regex. Members whose name does not match any of the regexes will be excluded
    # @return [Array<Struct>] declared inner-structs (inner-classes are excluded)
    def only_innerstructs(access = :public, filter = nil)
    	if access == :all
    		return innerstructs(:public, filter) + innerstructs(:protected, filter) + innerstructs(:private, filter) 
    	end
      lst = doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
      lst = lst.select { |c| c["refid"].start_with?("struct") }
      do_filter(filter, lst, Doxyparser::Struct) { |node|
        del_prefix(node.child.content)
      }
    end
    
    # @param access [Symbol] access modifier (:public, :protected, :private, :all)
    # @return [Array<Type>] declared super-types for this struct/class
    def parent_types(access = :public)
    	if access == :public
    		@public_parent_types ||= _parent_types(:public)
    		return @public_parent_types
    	end
    	if access == :all
    			@all_parent_types ||= parent_types(:public) + parent_types(:protected) + parent_types(:private)
    			return @all_parent_types	
    	end
      _parent_types(access)
    end
    
    # @param access [Symbol] access modifier (:public, :protected, :private, :all)
    # @param filter [Array<String>] list of Regex. Members whose name does not match any of the regexes will be excluded
    # @return [Array<Enum>] declared enums
    def enums(access = :public, filter = nil)
    	if access == :public && filter.nil?
    		@public_enums ||= _enums(:public)
    		return @public_enums 
    	end
    	if access == :all && filter.nil?
    		@all_enums ||= enums(:public) + enums(:protected) + enums(:private)
    		return @all_enums  
    	end
      _enums(access, filter)
    end
    
	  # @param access [Symbol] access modifier (:public, :protected, :private, :all)
    # @param filter [Array<String>] list of Regex. Members whose name does not match any of the regexes will be excluded
    # @return [Array<Typedef>] declared typedefs
    def typedefs(access = :public, filter = nil)
    	if access == :public && filter.nil?
    		@public_typedefs ||= _typedefs(:public)
    		return @public_typedefs 
    	end
    	if access == :all && filter.nil?
    		@all_typedefs ||= typedefs(:public) + typedefs(:protected) + typedefs(:private)
    		return @all_typedefs 
    	end
      _typedefs(access, filter)
    end

    
   	attr_reader :file
  	attr_reader :friends
  	attr_reader :template_params

    private
    
    def _methods(access = :public, static = nil, filter = nil)
    	if static.nil?
        static = "-"
      else
        static = "-static-"
      end
      sectiondef = %Q{#{access}#{static}func}
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="function"][@prot="#{access}"]})
      do_filter(filter, lst, Doxyparser::Function) { |node|
        node.xpath("name")[0].child.content
      }
    end
    
    def _attributes(access = :public, static = nil, filter = nil)
    	if static.nil?
        static = "-"
      else
        static = "-static-"
      end
      sectiondef = %Q{#{access}#{static}attrib}
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="variable"][@prot="#{access}"]})
      do_filter(filter, lst, Doxyparser::Variable) { |node|
        node.xpath("name")[0].child.content
      }
    end

    def compute_path
      aux = escape_class_name(@name)
      @xml_path = %Q{#{@dir}/struct#{aux}.xml}
    end
    
    def _typedefs(access, filter=nil)
    	sectiondef = %Q{#{access}-type}
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="typedef"][@prot="#{access}"]})
      do_filter(filter, lst, Doxyparser::Typedef) { |node| 
      	del_spaces node.xpath("name")[0].child.content
      }
    end
    
    def _enums(access, filter=nil)
    	sectiondef = %Q{#{access}-type}
      lst = doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="#{sectiondef}"]/memberdef[@kind="enum"][@prot="#{access}"]})
      filter.map!{ |exp| exp =~ /^#{@basename}_Enum/ ? /@\d*/ : exp} unless filter.nil?
      do_filter(filter, lst, Doxyparser::Enum) { |node|
        node.xpath("name")[0].child.content
      }
    end
    
    def _parent_types(access)
    	doc.xpath(%Q{/doxygen/compounddef/basecompoundref[@prot="#{access}"]}).map { |t| 	Doxyparser::Type.new(name: t.child.content, dir: @dir) }
    end
    
    def init_attributes
  		super
  		@file = init_file
  		@friends = init_friends
  		@template_params = init_template_params
  	end

    def init_file
      n = doc.xpath("/doxygen/compounddef/includes")[0]
      return n ? HFile.new(dir: @dir, node: n) : nil 
    end

    def init_friends
      lst=doc.xpath(%Q{/doxygen/compounddef/sectiondef[@kind="friend"]/memberdef[@kind="friend"]})
      lst.map { |node|
        Doxyparser::Friend.new(parent: self, node: node)
      }
    end
    
    def init_template_params
      params=doc.xpath(%Q{/doxygen/compounddef/templateparamlist/param})
      params.map { |param|
        Doxyparser::Param.new(parent: self, node: param)
      }
    end
  end
end
