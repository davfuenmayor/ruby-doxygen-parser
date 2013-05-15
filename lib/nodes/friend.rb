module Doxyparser

  class Friend < Member

    def is_class?
      args.nil? || args == ""
    end
    
    def is_qualified?
      basename.include? '::'
    end
  end
end