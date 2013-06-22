module Doxyparser

  class Node
    include Doxyparser::Util

    attr_reader :dir
    attr_reader :name
    attr_reader :basename
    attr_reader :node
    attr_reader :doc
    attr_reader :parent

    def == another
      self.name == another.name
    end

    def eql?(another)
      self.name == another.name
    end

    def to_str
      @name
    end

    def to_s
      @name
    end

    # Takes a hash as input with following keys: :node, :parent, :dir, :name
    def initialize(hash)
      @dir = hash[:dir]
      @name = hash[:name]
      if hash[:node] # If a reference to an xml declaration (node) is given
        # then...
        @node = hash[:node]
        @parent = hash[:parent]
        @name = find_name
        @dir ||= @parent.dir unless @parent.nil?
      end
      raise "No name given for node: #{self.class.name}" unless @name
      raise "No xml directory given for node: #{self.class.name}" unless @dir
      init_attributes
    end

    private

    def method_missing(sym, *args)
      if @node.respond_to?(sym)
      @node.send(sym, *args)
      else
      @node[sym.to_s] || super
      end
    end

    def init_attributes
      @basename ||= del_prefix(@name)
    end

    def find_name
      # For Inheritance
    end

  end
end
