module Doxyparser

  class Type < Node

    def nested_local_types
      return [] if @node.nil?
      refs = @node.xpath("ref")
      return [] if refs.nil? || refs.empty?
      refs.map { |r| Type.new(node: r, dir: @dir) }
    end

    def nested_typenames
      Type.nested_typenames(@name)
    end

    def self.nested_typenames(typename)
      typename.split(%r{[<,>]}).map{ |s|
      	 s.gsub(/^ *const /,'').gsub(/ +(const)* *[&*] *(const)* *$/,'').strip 
      }.reject { |s| 
      		s.nil? || !valid_type?(s) 
      	}
    end

    def template?
      Type.template?(@name)
    end

    def self.template?(typename)
      typename.include? '<'
    end

    private

    def init_attributes
      @basename = @name
    end

    def find_name
      return '' if @node.nil?
      @node.content
    end

    def self.valid_type?(str)
      str =~ /^\D[\w_ :*&]*$/
    end

  end
end