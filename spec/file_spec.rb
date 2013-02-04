require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyFile" do

  before(:all) do
    @file=DoxyFile.new(:name=> "OgreUserObjectBindings.h",:dir=>File.expand_path("./xml"))    
    @innerclass_filter=["Ogre::UserObjectBindings"]    
    @innerclasses=[]    
  end
  
  it "should be created consistently from name and directory" do      
      @file.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/OgreUserObjectBindings_8h.xml}    
  end
  
  it "should have a null XML reference" do      
      @file.doc.should ==nil
  end
  
  it "should parse flawlessly the corresponding XML file" do    
    doc=@file.parse.doc
    doc.class.should == Nokogiri::XML::Document
  end
  
  it "should create the right classes according to a specified filter" do       
    @innerclasses << @file.get_classes(@innerclass_filter)
    @innerclasses.flatten!  
    @innerclasses.should_not be_empty
    @innerclasses.size.should == @innerclass_filter.size     # Should return same name of elements as the filter...
    @innerclasses.uniq.should == @innerclasses               # ... and no element should be repeated  
  end
  
  it "should create correctly the classes" do    
    @innerclasses.each{|c|
        # Class class must be correct
        c.class.should == DoxyClass
        
        # Class should have a null XML reference
        c.doc.should ==nil
        
        # Class should have a correct parent
        c.parent.should == @file
                  
        # name and file path must be correct (Visual inspection)        
        puts "Inner Class Name:   " +c.name
        puts "File Location:   " +c.path
        
        # The classes must be included in the given filter
        @innerclass_filter.should include c.name        
    }    
  end
  
  
end