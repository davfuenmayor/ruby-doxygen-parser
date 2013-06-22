module Doxyparser

  class Class < Struct

    private

    def compute_path
      aux = escape_class_name(@name)
      @xml_path = %Q{#{@dir}/class#{aux}.xml}
    end

  end
end