module Doxyparser

	# A C/C++ function with its parameters und return type 
  class Function < Member

	  # @return true if the function is a constructor of a {Struct} or {Class}
    def constructor?
      @basename == parent.basename
    end

		# @return true if the function is a destructor of a {Struct} or {Class}
    def destructor?
      @basename.start_with? %Q{~}
    end

		# Finds the name of the -hypothetical- property this method refers to in case this {Function} complies 
		# with the 'getter' naming convention and has no parameters.  
		# Getter examples for 'myProperty' are: getMyProperty, get_myProperty, GetMyProperty, Get_MyProperty, etc
		# Getter examples for 'booleanProp' are: isBooleanProp, is_booleanProp, get_booleanProp, etc  
		# @return [String] name of the property  
    def getter_for    	
    	return nil if @type.name == 'void'
    	
      if @params.empty? || (@params.size == 1 && @params[0].type.name.strip == 'void')
        if @basename.start_with?('get') || @basename.start_with?('Get')
          ret = @basename.gsub(/^get[_]?(\w)/i) { |match| $1.downcase }
          ret.prepend('_') if ret =~ %r{^\d}
          return ret
        end
        if @type.name == 'bool'
          if @basename.start_with?('is') || @basename.start_with?('Is')
            ret = @basename.gsub(/^is[_]?(\w)/i) { |match| $1.downcase }
            ret.prepend('_') if ret =~ %r{^\d}
          	return ret
          end
        end
      end
      return nil
    end

	  # Finds the name of the -hypothetical- property this method refers to in case this {Function} complies 
		# with the 'setter' naming convention and has no return value (void).  
		# Setter examples for 'myProperty' are: setMyProperty, set_myProperty, SetMyProperty, Set_MyProperty, etc
		# @return [String] name of the property  
    def setter_for
      if (@type.name == 'void') && (@params.size == 1 && @params[0].type.name.strip != 'void')
        if @basename.start_with?('set') || @basename.start_with?('Set')
          ret = @basename.gsub(/^set[_]?(\w)/i) { |match| $1.downcase }
          ret.prepend('_') if ret =~ %r{^\d}
          return ret
        end
      end
      return nil
    end
    
    def == another
      super
      self.args == another.args
    end

    def eql?(another)
      super
      self.args == another.args
    end
    
    def to_str
      super + @args
    end

    def to_s
      super + @args
    end
  end
end