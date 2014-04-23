module Doxyparser

	# A friend member declared inside a C++ {Class}. Can itself refer to an external {Function} or {Class}
  class Friend < Member

		# @return true if the friend declaration refers to a {Class} false if refers to a {Function}
    def is_class?
      args.nil? || args == ""
    end

		# @return true if the name used in the declaration is fully qualified (using the '::' operator) false otherwise
    def is_qualified?
      basename.include? '::'
    end

    private

    def find_name
      @basename = @node.xpath("name")[0].child.content
      @parent.name + '::' + @basename
    end
  end
end