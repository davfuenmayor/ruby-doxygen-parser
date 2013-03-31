module Doxyparser

  class Struct < Compound

    def members access="public", filter=nil
      get_variables filter, access
    end

    def file
      get_file
    end

    def typedefs
      get_typedefs
    end

    private

    def compute_path
      aux = escape_class_name @name
      @path = %Q{#{@dir}/struct#{aux}.xml}
    end
  end
end