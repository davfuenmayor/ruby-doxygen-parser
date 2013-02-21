class DoxyException
  class << self
    def bad_doc name="", type=""
      %Q{#{type} #{name} does not have correctly generated documentation. Check if its definition in the corresponding include file (.h) has a Doxygen valid comment (e.g /**) or set EXTRACT_ALL to YES in the corresponding Doxyfile and generate the XML documentation again}
    end
    def no_node_assoc name="", type=""
      %Q{This object: #{type} #{name} has not yet been associated to an xml node}
    end
    
    def no_parent_assoc name="", type=""
      %Q{Node #{type} #{name} was defined but no parent was found}
    end
    
    def no_file_assoc name="", type="", path=""
      %Q{No file could be found at this location: #{path} for node #{type} #{name}}
    end
   end
end