module Doxyparser

  class Namespace < Compound

    def functions access="public", filter=nil
      sectiondef = "func"
      get_functions filter, sectiondef, access
    end

    def variables access="public", filter=nil
      sectiondef = "var"
      get_variables filter, sectiondef, access
    end

    def classes access="public", filter=nil
      get_classes filter, access
    end

    def innernamespaces filter=nil
      get_namespaces filter
    end

    def typedefs
      get_typedefs
    end

    def structs access="public", filter=nil
      get_structs filter, access
    end

    def enums access="public", filter=nil
      get_enums filter, "enum", access
    end

    def file
      nil
    end

    private

    def compute_path
      aux = escape_class_name(@name)
      @path = %Q{#{@dir}/namespace#{aux}.xml}
    end
  end
end