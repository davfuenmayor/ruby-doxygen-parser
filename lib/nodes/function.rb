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
      ret = nil
      if @args == '()'
        ret = @basename.start_with?(/get/i) ? m.name.gsub(/get[_]?(\w)/i){|match| $1.downcase} : nil
        ret ||= @basename.start_with?(/is/i) ? m.name.gsub(/is[_]?(\w)/i){|match| $1.downcase} : nil
      end
      ret
    end

    def setter_for
      ret = nil
      if @type == 'void'
        ret = @basename.start_with?(/set/i) ? m.name.gsub(/set[_]?(\w)/i){|match| $1.downcase} : nil
      end
      ret
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
        temp = ""
        param.xpath("type//text()").each { |n| temp << n.content }
        @params << temp
      }
    end
  end
end