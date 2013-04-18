require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "Doxyparser::HFile" do

  before(:all) do
    @file=Doxyparser::HFile.new(:name=> "OgreUserObjectBindings.h",:dir=>File.expand_path(__dir__+"/xml"))
    @innerclass_filter=["Ogre::UserObjectBindings"]    
    @innerclasses=[]    
  end
  
  it "should be created consistently from name and directory" do      
      @file.path.should == __dir__+%Q{/xml/OgreUserObjectBindings_8h.xml}
  end
   
  it "should parse flawlessly the corresponding XML file" do    
    doc=@file.doc
    doc.class.should == Nokogiri::XML::Document
    puts 'Includes: \n' + @file.includes.join(', ')
    puts 'Included by: \n' + @file.included_by.join(', ')
  end
  
  it "should create the right classes according to a specified filter" do 
    var=@file.classes('public',@innerclass_filter)
    @innerclasses.push(*var) 
    
    puts "Class Name:"+ @innerclasses.class.name 
    puts "InnerClasses to String:"+ @innerclasses.to_s   
     
    @innerclasses.should_not be_empty
    @innerclasses.size.should == @innerclass_filter.size     # Should return same name of elements as the filter...
    @innerclasses.uniq.should == @innerclasses               # ... and no element should be repeated  
  end
  
  it "should create correctly the classes" do    
    @innerclasses.each{|c|
        # Class class must be correct
        c.class.should == Doxyparser::Class
        
        # Class should have a correct parent
        c.parent.should == nil
                  
        # name and file path must be correct (Visual inspection)        
        puts "Inner Class Name:   " +c.name
        puts "Inner Class Base Name:   " +c.basename
        puts "File Location:   " +c.path
        
        # The classes must be included in the given filter
        @innerclass_filter.should include c.name        
    }    
  end
  
  
end