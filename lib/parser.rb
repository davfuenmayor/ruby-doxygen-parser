module DoxyParser  
    def escape_class_name classname 
      classname.gsub(/.*::/i,"").gsub(/\s*/i,"")
    end
    
    def parse_namespace path
      raise "There is no XML File associated to this namespace" unless File.exists? path
      doc=nil
      File.open(path){ |namespace|         
        doc=Nokogiri::XML(namespace)        
      }
      doc 
    end
    
    def parse_class cls, dir
      dir = File.expand_path(dir)
      raise "Given directory does not exist" unless Dir.exists? dir
      nsxml = %Q{#{dir}/namespace#{ns}.xml} 
      raise "There is no XML File associated to this namespace" unless File.exists? nsxml
      doc=nil
      File.open(nsxml){ |namespace|         
        doc=Nokogiri::XML(namespace)        
      }
      doc 
    end    
     
    def read_file(file_name)
      file = File.open(file_name, "r")
      data = file.read
      file.close
      return data
    end
    
    def write_file(file_name, data)
      file = File.open(file_name, "w")
      count = file.write(data)
      file.close  
      return count
    end 
end