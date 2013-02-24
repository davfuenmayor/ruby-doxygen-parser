class DoxyEnum < DoxyMember
   
   def values
     ret=[]
     xpath("enumvalue/name").each{ |v| ret << v.child.content}
     ret
   end
end