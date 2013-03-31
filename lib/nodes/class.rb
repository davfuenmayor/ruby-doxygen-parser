module Doxyparser

  class Class < Compound


    def methods access="public", static=nil, filter=nil
      if static.nil?
        static="-"
      else
        static="-static-"
      end
      sectiondef=%Q{#{access}#{static}func}
      get_functions filter, sectiondef, access
    end

    def attributes access="public", static=nil, filter=nil
      if static.nil?
        static="-"
      else
        static="-static-"
      end
      sectiondef=%Q{#{access}#{static}attrib}
      get_variables filter, sectiondef, access
    end

    def innerclasses access="public", filter=nil
      get_classes filter, access
    end

    def innerstructs access="public", filter=nil
      get_structs filter, access
    end

    def innerenums access="public", filter=nil
      sectiondef=%Q{#{access}-type}
      get_enums filter, sectiondef, access
    end

    def typedefs
      get_typedefs
    end

    private

    def compute_path
      aux = escape_class_name @name
      @path = %Q{#{@dir}/class#{aux}.xml}
    end

  end
end