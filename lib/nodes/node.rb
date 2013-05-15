module Doxyparser

  class Node
    include Doxyparser::Util

    attr_reader :dir
    attr_reader :name
    attr_reader :basename
    attr_reader :node
    attr_reader :doc
    attr_reader :parent
    attr_reader :xml_path

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

	# Takes a hash as input with following keys: :node, :parent, :dir, :name
    def initialize hash
      @doc = nil
      @xml_path = nil
      @node = nil

      # If an explicit directory is given it takes precedence
      if hash[:dir]
        @dir = hash[:dir]
      end
      # If a reference to an xml declaration (node) is given then...
      if hash[:node]
        # ...A parent node must also be given
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
      raise Doxyparser::Exception.no_file_assoc(@name, self.class.name, @xml_path) unless File.exists? @xml_path
      if File.extname(@xml_path)==".xml"
        File.open(@xml_path) { |xml_doc|
          @doc=Nokogiri::XML(xml_doc)
        }
      else
        @doc = @node
      end
      self
    end
    
    def compute_attr
      # For inheritance
    end

    def compute_name name, parent=nil
      if parent
        @basename = name
        @name = parent.name+"::"+@basename
      else
        @name = name
        @basename = del_prefix name
      end
    end
  end
end
