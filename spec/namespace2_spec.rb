require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyNamespace" do

  before(:all) do
    @namespace=DoxyNamespace.new(:name=> "Ogre",:dir=>File.expand_path("./xml"))
    doc=@namespace.doc
    @func_filter=["FastHash", "findCommandLineOpts", "rawOffsetPointer"]
    @enum_filter=["VertexAnimationType", "FogMode", "ManualCullingMode"]
    @functions=[]
    @enums=[]
  end
  
  it "should create the right functions according to a specified filter" do     
    @functions << @namespace.functions(@func_filter)
    @functions.flatten!
    @functions.should_not be_empty
    puts @functions.size
  end
  
  it "should create correctly the functions" do    
    @functions.each{|f|
        # The class of the Function Node must be correct
        f.class.should == DoxyFunction
        
        # Functions should have a correct parent
        f.parent.should == @namespace
                  
        # name and .h file path must be correct (Visual inspection)
        puts "Function Name:   " +f.name
        puts "File Location:   " +f.location
        puts "Function Definition:   " +f.definition
        puts "Function Arguments:   " +f.args
        
        # The functions must be included in the given filter
        @func_filter.should include f.name       
    }    
  end
  
  it "should create the right enums according to a specified filter" do 
    @enums << @namespace.enums(@enum_filter)
    @enums.flatten!
    @enums.should_not be_empty 
    @enums.uniq.should == @enums               # ... and no element should be repeated     
  end
  
  it "should create correctly the enums" do    
    @enums.each{|f|
        # The class of the Enum Node must be correct
        f.class.should == DoxyEnum
        
        # Enums should have a correct parent
        f.parent.should == @namespace
                  
        # name and .h file path must be correct (Visual inspection)        
        puts "Enum Name:   " +f.name
        puts "File Location:   " +f.location
        puts "Enum Values:   " +f.values.join(", ")
        puts "Enum  Definition:   " +f.definition
        
        # The enums must be included in the given filter
        @enum_filter.should include f.name                  
    }    
  end
end