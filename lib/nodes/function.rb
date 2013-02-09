class DoxyFunction < DoxyMember
  
  def file
    aux=%Q{#{@name}}.gsub(".","_8")
    DoxyFile.new name, dir
  end
      
 
end