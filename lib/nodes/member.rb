module Doxyparser

  class Member < Node

    attr_reader :location
    attr_reader :definition
    attr_reader :args
    attr_reader :type
    attr_reader :static
    attr_reader :params

    def file
      HFile.new(:name => @filename, :dir => @dir)
    end

    private

    def init_attributes
      super
      raise "No XML node was associated to this member" if @node.nil?
      @xml_path = parent.xml_path

      if @node['static'] && @node['static'] == 'yes'
        @static = 'static'
      else
        @static = nil
      end

      aux = self.xpath("location")[0]
      @filename = File.basename(aux["file"])
      @location = "#{aux["file"]}:#{aux["line"]}"
      temp = self.xpath("definition")
      if temp == nil || temp.empty? || temp[0].child==nil
        @definition = ""
      else
        @definition = temp[0].child.content
      end
      temp = self.xpath("argsstring")
      if temp == nil || temp.empty? || temp[0].child==nil
        @args = ""
      else
        @args = temp[0].child.content
      end
      @type = find_type(@node)

      @params = []
      all_params = self.xpath("param")
      return if all_params == nil || all_params.empty? || all_params[0].child==nil

      all_params.each { |param|
        @params << Doxyparser::Param.new(node: param, parent: self, name: 'param')
      }
    end

    def find_name
      @parent.name + '::' + @node.xpath("name")[0].child.content
    end

    def find_type(n)
      type = n.xpath("type")
      return Type.new(name: '', dir: @dir) if type.nil? || type.empty? || type[0].child == nil
      Type.new(node: type[0], dir: @dir)
    end
  end
end