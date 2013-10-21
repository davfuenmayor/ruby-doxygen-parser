module Doxyparser

  class Type < Node
  	
  	attr_reader :escaped_name

    def nested_local_types
      return [] if @node.nil?
      refs = @node.xpath("ref")
      return [] if refs.nil? || refs.empty?
      refs.map { |r| Type.new(node: r, dir: @dir) }
    end

    def nested_typenames
      Type.nested_typenames(@basename)
    end

    def self.nested_typenames(typename)
    	escaped_typename = Doxyparser::Util.escape_const_ref_ptr(typename)
      escaped_typename.split(%r{[<,>]}).map{ |s|
      	 Doxyparser::Util.escape_const_ref_ptr(s)
      }.reject { |s| 
      		s.nil? || !valid_type?(s) 
      }
    end

    def template?
      Type.template?(@basename)
    end

    def self.template?(typename)
      typename.include? '<'
    end
    
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