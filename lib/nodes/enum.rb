module Doxyparser

	# A C/C++ Enumeration
  class Enum < Member

		# [Array<EnumValue>] List of values
    attr_reader :values

    private

    def init_attributes
      super
      @values= []
      all_values = self.xpath("enumvalue")
      return if all_values.nil? || all_values.empty?
      all_values.each { |enumvalue|
        @values << Doxyparser::EnumValue.new(node: enumvalue, parent: self)
      }
    end

    def find_name
      super.gsub(/@\d*/) {
        prefix = (parent.class == Doxyparser::Namespace) ? 'ns_' : ''
        if (parent.class == Doxyparser::HFile)
        	enum_name = 'file_' + escape_file_name(parent.basename.gsub(/\.\w+$/, '')) 
        else
        	enum_name = parent.basename
        end
        "#{prefix}#{enum_name}_Enum"
      }
    end
  end
end
