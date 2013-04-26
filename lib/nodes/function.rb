module Doxyparser

  class Function < Member

    attr_reader :params

    def constructor?
      @basename==parent.basename
    end

    def destructor?
      @basename.start_with? %Q{~}
    end

    def getter_for
      if @params.empty? || (@params.size == 1 && @params[0].type =~ /\s*void\s*/)
        if @basename.start_with?('get') || @basename.start_with?('Get')
          return @basename.gsub(/get[_]?(\w)/i){|match| $1.downcase}        
        end
        if @basename.start_with?('is') || @basename.start_with?('Is')
          return @basename.gsub(/is[_]?(\w)/i){|match| $1.downcase}
        end
      end           
      return nil
    end

    def setter_for
      if @type == 'void'
        if @basename.start_with?('set') || @basename.start_with?('Set')
          return @basename.gsub(/set[_]?(\w)/i){|match| $1.downcase}        
        end      
      end
      return nil
    end

    private

    def compute_attr
      super
      @params=[]
      all_params= self.xpath("param")
      if all_params == nil || all_params.empty? || all_params[0].child==nil
      return
      end
      all_params.each { |param|
        decl_name= param.xpath("declname")
        if decl_name == nil || decl_name.empty? || decl_name[0].child==nil
          decl_name = ""
        else
        decl_name = decl_name[0]
        end
        @params << Param.new(find_type(param),decl_name)
      }
    end
  end
end