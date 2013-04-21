module Doxyparser

  class Param

    attr_reader :type
    attr_reader :decl_name
    
    def initialize type, decl_name
      @type = type
      @decl_name = decl_name
    end
  end
end