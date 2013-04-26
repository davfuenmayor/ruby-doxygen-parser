module Doxyparser

  class Node
    include Doxyparser::Util

    attr_reader :dir
    attr_reader :name
    attr_reader :basename
    attr_reader :node
    attr_reader :parent
    #@doc
    attr_reader :path

    def == another
      self.name == another.name
    end

    def eql? another
      self.name == another.name
    end

    def to_str
      @name
    end

    def to_s
      @name
    end

    def method_missing sym, *args
      #raise Doxyparser::Exception.no_node_assoc(@name, self.class.name) unless @node #TODO
      if @node.respond_to? sym
        @node.send(sym, *args)
      else
        @node[sym.to_s] || super
      end
    end

    def doc
      if @doc==nil
        parse
      end
      @doc
    end

    protected

    def initialize hash
      @doc = nil
      @path = nil
      @node = nil

      # If an explicit directory is given it takes precedence
      if hash[:dir]
        @dir = hash[:dir]
      end
      # If a reference to an xml declaration (node) is given
      if hash[:node]
        # A parent must also be given
        if hash[:parent]
          @parent = hash[:parent]
          @dir ||= parent.dir # Only if @dir is nil
        else
          raise Doxyparser::Exception.no_parent_assoc(hash[:name], self.class.name)
        end

        @node= hash[:node]

        if hash[:name]
          compute_name hash[:name], @parent
        else
          compute_name self.xpath("name")[0].child.content, @parent
        end

      else
        raise Doxyparser::Exception.no_name_given(self.class.name) unless hash[:name]
        compute_name hash[:name]
      end

      compute_attr
    end

    private

    def parse
      raise Doxyparser::Exception.no_file_assoc(@name, self.class.name, @path) unless File.exists? @path
      if File.extname(@path)==".xml"
        File.open(path) { |namespace|
          @doc=Nokogiri::XML(namespace)
        }
      else
        @doc = @node
      end
      self
    end

    def compute_attr
      if @node
        @path = %Q{#{@dir}/#{self.id}.xml}
      end
    end

    def compute_name name, parent=nil
      if parent
        @basename = del_prefix name
        @name = parent.name+"::"+@basename
        #puts "Parent Given:"
      else
        @name = name
        @basename = del_prefix name
      end
    end
  end
end
