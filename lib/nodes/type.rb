module Doxyparser

	# Type of the parameters and return value of a {Function}. Parent Type of a {Class} or {Struct}. 
	# 	Supports type parameters (aka. generics) 
  class Type < Node
  	
  	# Name of this {Type} without any reference/pointer symbols '* &' or 'const' modifiers
  	attr_reader :escaped_name

		# If this {Type} has type parameters (aka. template params) finds nested {Type}s 
		#    for other {Class}es or {Struct}s parsed by Doxyparser.
		#  	The 'main' type is always included, so for templates two or more types will be returned. 
		# Example: for MyNamespace::map<std::string, MyClass> the result is: [MyNamespace::map, MyNamespace::MyClass]  
		# @return [Array<Type>] Nested types
    def nested_local_types
      return [] if @node.nil?
      refs = @node.xpath("ref")
      return [] if refs.nil? || refs.empty?
      refs.map { |r| Type.new(node: r, dir: @dir) }
    end

		# If this {Type} has type parameters (aka. template params), returns the names for
		# 	 types nested in this type's name
		#  	The 'main' type is always included, so for templates two or more names will be returned.
		# Example: for MyNamespace::map<std::string, MyClass, 4> the result is: [MyNamespace::map, std::string, MyClass]  
		# @return [Array<String>] Names of nested types
    def nested_typenames
      Type.nested_typenames(@escaped_name)
    end

		# Returns the names for types nested in the parameter.
		#  	The 'main' type is always included, so for templates two or more names will be returned.
		# Example: for mymap<std::string, MyClass, 4> the result is: [mymap, std::string, MyClass]
		# @param typename [String] Type name  
		# @return [Array<String>] Names of nested types
    def self.nested_typenames(typename)
    	escaped_typename = Doxyparser::Util.escape_const_ref_ptr(typename)
      escaped_typename.split(%r{[<,>]}).map{ |s|
      	 Doxyparser::Util.escape_const_ref_ptr(s)
      }.reject { |s| 
      		s.nil? || !valid_type?(s) 
      }
    end

		# @return true if this type has type parameters, false otherwise
    def template?
      Type.template?(@escaped_name)
    end

		# @param typename [String] Type name
		# @return true if the given type name has type parameters, false otherwise 
    def self.template?(typename)
      typename.include? '<'
    end
    
    # Setter for the name of this {Type}. Use at your own risk!
    def name=(new_name)
    	@name = new_name
    	@escaped_name = escape_const_ref_ptr(@name)
      @basename = del_prefix_class(escape_template(@escaped_name))
    end

    private

    def init_attributes
      @escaped_name = escape_const_ref_ptr(@name)
      @basename = del_prefix_class(escape_template(@escaped_name))
    end

    def find_name
      return '' if @node.nil?
      @node.content.gsub('friend', '').strip
    end

    def self.valid_type?(str)
      str =~ /^\D[\w_ :*&]*$/
    end

  end
end