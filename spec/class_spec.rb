require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyClass" do

  before(:all) do
    @class=DoxyClass.new(:name=> "Ogre::UserObjectBindings",:dir=>File.expand_path("./xml"))
    @func_filter=["UserObjectBindings", "setUserAny", "getEmptyUserAny"]
    @enum_filter=nil
    @innerclass_filter=["Ogre::UserObjectBindings::Attributes"]
    @functions=[]
    @enums=[]
    @innerclasses=[]
    @file=nil
  end
  
  it "should be created consistently from name and directory" do      
      @class.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/classOgre_1_1UserObjectBindings.xml}    
  end
  
  it "should have a null XML reference" do      
      @class.doc.should ==nil
  end
  
  it "should parse flawlessly the corresponding XML file" do    
    doc=@class.parse.doc
    doc.class.should == Nokogiri::XML::Document
  end
  
  it "should create the correct include File" do
    @file = @class.get_file
    # name and file path must be correct (Visual inspection)        
    puts "Include File Name:   " +@file.name
    puts "File Location:   " +@file.path          
  end 
  
  it "should create the right inner classes according to a specified filter" do       
    @innerclasses << @class.get_classes(@innerclass_filter)
    @innerclasses.flatten!  
    @innerclasses.should_not be_empty
    @innerclasses.size.should == @innerclass_filter.size     # Should return same name of elements as the filter...
    @innerclasses.uniq.should == @innerclasses               # ... and no element should be repeated        
  end
  
  it "should create correctly the inner classes" do    
    @innerclasses.each{|c|
        # Class class must be correct
        c.class.should == DoxyClass
        
        # Class should have a null XML reference
        c.doc.should ==nil
        
        # Class should have a correct parent
        c.parent.should == @class
                  
        # name and file path must be correct (Visual inspection)        
        puts "Inner Class Name:   " +c.name
        puts "File Location:   " +c.path
        
        # The classes must be included in the given filter
        @innerclass_filter.should include c.name        
    }    
  end
  
  it "should create the right functions according to a specified filter" do       
    @functions << @class.get_functions(@func_filter)
    @functions.flatten!  
    @functions.should_not be_empty       
  end
  
  
end