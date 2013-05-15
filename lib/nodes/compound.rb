module Doxyparser

  class Compound < Node
  	
  	attr_reader :number_unnamed

    def file
      n=doc.xpath("/doxygen/compounddef/includes")[0]
      raise "#{self.name} #{self.class.name} does not have correctly generated documentation. Use 'EXTRACT_ALL' Doxygen flag" if n.nil?
      HFile.new(dir: @dir, name: n.child.content)
    end
    
    def compute_attr
    	@number_unnamed = 0
      if @node
        @xml_path = %Q{#{@dir}/#{self.refid}.xml}
      else
        compute_path
      end
    end
    
  end

end