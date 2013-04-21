module Doxyparser

  class Member < Node

    attr_reader :location
    attr_reader :definition
    attr_reader :args
    attr_reader :type

    def file
      HFile.new(:name => @file, :dir => @dir)
    end

    private

    def compute_attr
      if @node
        @path=@dir
        aux= self.xpath("location")[0]
        @file=File.basename(aux["file"])
        @location=%Q{#{aux["file"]}:#{aux["line"]}}
        temp=self.xpath("definition")
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
        @type = find_type @node
      else
        raise "No XML node was associated to this enum"
      end
    end

    def find_type n
      type = nil
      temp = n.xpath("type")
      return "" if temp.nil? || temp.empty? || temp[0].child==nil
      temp_ref = temp[0].xpath("ref")
      type = temp[0].content
    end
  end
end