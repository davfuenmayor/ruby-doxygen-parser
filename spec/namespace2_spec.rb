require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyNamespace" do

  before(:all) do
    @namespace=DoxyNamespace.new(:name=> "Ogre",:dir=>File.expand_path("./xml"))
    doc=@namespace.parse.doc
    @func_filter=["FastHash", "findCommandLineOpts", "rawOffsetPointer"]
    @enum_filter=["VertexAnimationType", "FogMode", "ManualCullingMode"]
    @functions=[]
    @enums=[]
  end
  
  it "should create the right functions according to a specified filter" do     
    @functions << @namespace.get_functions(@func_filter)
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
        puts "File Location:   " +f.path
        
        # The functions must be included in the given filter
        @func_filter.should include f.name       
    }    
  end
  
  it "should create the right enums according to a specified filter" do 
    @enums << @namespace.get_enums(@enum_filter)
    @enums.flatten!
    @enums.should_not be_empty  
    puts @enums.size  
      #@namespace.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/namespaceOgre.xml}    
  end
  
  it "should create correctly the enums" do    
    @enums.each{|f|
        # The class of the Enum Node must be correct
        f.class.should == DoxyEnum
        
        # Enums should have a correct parent
        f.parent.should == @namespace
                  
        # name and .h file path must be correct (Visual inspection)        
        puts "Enum Name:   " +f.name
        puts "File Location:   " +f.path
        
        # The enums must be included in the given filter
        @enum_filter.should include f.name                  
    }    
  end
end