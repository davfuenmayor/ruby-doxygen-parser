require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "DoxyNamespace" do

  before(:all) do
    @namespace=DoxyNamespace.new(:name=> "MyNamespace",:dir=>File.expand_path(__dir__+"/xml"))
    doc=@namespace.doc
    @func_filter=["function1", "function2"]
    @functions=[]
    @variables=[]
    @structs=[]
    @innernamespaces=[]
    @enums=[]
  end
  
  it "should create the right functions according to a specified filter" do     
    @functions << @namespace.functions(@func_filter)
    @functions.flatten!
    @functions.should_not be_empty
    puts "Total number of functions: " + @functions.size.to_s
  end
  
  it "should create correctly the functions" do    
    @functions.each{|f|
        # The class of the Function Node must be correct
        f.class.should == DoxyFunction
        
        # Functions should have a correct parent
        f.parent.should == @namespace
                  
        # name and .h file path must be correct (Visual inspection)
        puts "Function Name:   " +f.name
        puts "Function Base Name:   " +f.basename
        puts "File Location:   " +f.location
        puts "Function Definition:   " +f.definition
        puts "Function Arguments:   " +f.args
        
        # The functions must be included in the given filter
        @func_filter.should include f.basename       
    }    
  end
    
  it "should create correctly the enums" do
    @enums << @namespace.enums
    @enums.flatten!
    @enums.should_not be_empty 
    @enums.uniq.should == @enums               # ... and no element should be repeated    
    @enums.each{|f|
        # The class of the Enum Node must be correct
        f.class.should == DoxyEnum
        
        # Enums should have a correct parent
        f.parent.should == @namespace
                  
        # name and .h file path must be correct (Visual inspection)        
        puts "Enum Name:   " +f.name
        puts "Enum Base Name:   " +f.basename
        puts "File Location:   " +f.location
        puts "Enum Values:   " +f.values.join(", ")
        puts "Enum  Definition:   " +f.definition                        
    }    
  end
  
  it "should create correctly the structs" do
    @structs << @namespace.structs
    @structs.flatten!  
    @structs.should_not be_empty    
    @structs.uniq.should == @structs
    @structs.each{|s|
        # Class must be correct
        s.class.should == DoxyStruct
        
        # Class should have a correct parent
        s.parent.should == @namespace
                  
        # XML File path must be correct
        s.path.should == __dir__+%Q{/xml/#{s.refid}.xml}
        
        # name and .h file path must be correct (Visual inspection)        
        puts "Struct Name:   " +s.name
        puts "Struct Base Name:   " +s.basename
        puts "File Location:   " +s.path   
    } 
  end
  
  it "should create correctly the variables" do
    @variables << @namespace.variables
    @variables.flatten!
    @variables.should_not be_empty 
    @variables.uniq.should == @variables               # ... and no element should be repeated    
    @variables.each{|f|
        # The class of the Enum Node must be correct
        f.class.should == DoxyVariable
        
        # Enums should have a correct parent
        f.parent.should == @namespace
                  
        # name and .h file path must be correct (Visual inspection)        
        puts "Variable Name:   " +f.name
        puts "Variable Name:   " +f.basename
        puts "Variable Location:   " +f.location
        puts "Variable  Definition:   " +f.definition                        
    }    
  end
  
  it "should create correctly the inner namespaces" do
    @innernamespaces << @namespace.innernamespaces
    @innernamespaces.flatten!
    @innernamespaces.should_not be_empty 
    @innernamespaces.uniq.should == @innernamespaces               # ... and no element should be repeated    
    @innernamespaces.each{|f|
        # The class of the Enum Node must be correct
        f.class.should == DoxyNamespace
        
        # Enums should have a correct parent
        f.parent.should == @namespace
                  
        # name and .h file path must be correct (Visual inspection)        
        puts "Namespace Name:   " +f.name
        puts "Namespace Base Name:   " +f.basename
        puts "File Location:   " +f.path  
        puts "Namespace Classes  " 
        
        f.classes.each{|c|
          # Class must be correct
          c.class.should == DoxyClass
          
          # Class should have a correct parent
          c.parent.should == f
                    
          # XML File path must be correct
          c.path.should == __dir__+%Q{/xml/#{c.refid}.xml}
          
          # name and .h file path must be correct (Visual inspection)        
          puts "\tClass Name:   " +c.name
          puts "\tClass Base Name:   " +c.basename
          puts "\tFile Location:   " +c.path      
        }                             
    }    
  end
end