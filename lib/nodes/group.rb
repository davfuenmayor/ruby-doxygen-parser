module Doxyparser

  class Group < Compound

    def classes access="public", filter=nil
      lst=doc.xpath(%Q{/doxygen/compounddef/innerclass[@prot="#{access}"]})
      lst = lst.select { |c| c["refid"].start_with?("class") }
      filtered_lst=lst
      if filter
        filtered_lst=lst.select { |node|
          filter.include? del_spaces(node.child.content)
        }
      end
      filtered_lst.map { |c| Doxyparser::Class.new(:dir => @dir, :name => del_spaces(c.child.content)) }
    end

    def file
      nil
    end

    private

    def compute_path
      @path = %Q{#{@dir}/group__#{@name}.xml}
    end

  end
end