require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "Doxyparser::HFile" do

  before(:all) do
    @file=Doxyparser::HFile.new(:name=> "test.h",:dir=>File.expand_path(__dir__+"/xml"))
    @classes=[]
    @structs=[]
    @enums=[]
    @namespaces=[]
    @variables=[]
    @functions=[]        
  end
  
  it "should be created consistently from name and directory" do      
      @file.path.should eql __dir__+%Q{/xml/test_8h.xml}
  end
   
  it "should parse flawlessly the corresponding XML file" do    
    doc=@file.doc
    doc.class.should eql Nokogiri::XML::Document
  end
  
  it "should create correctly the classes" do 
    var=@file.classes
    @classes.push(*var)           
    @classes.should_not be_empty
    @classes.uniq.should eql @classes               # ... and no element should be repeated
    
    @classes.each{|c|
        # Class class must be correct
        c.class.should eql Doxyparser::Class
        # Class should have a correct parent
        c.parent.should eql nil
                  
        # name and file path must be correct (Visual inspection)        
        puts "Class Name:   " +c.name
        puts "Class Base Name:   " +c.basename
        puts "File Location:   " +c.path              
    } 
  end
  
  it "should create correctly the structs" do 
    var=@file.structs
    @structs.push(*var)           
    @structs.should_not be_empty
    @structs.uniq.should eql @structs               # ... and no element should be repeated
    
    @structs.each{|c|
        # Class class must be correct
        c.class.should eql Doxyparser::Struct
        # Class should have a correct parent
        c.parent.should eql nil
                  
        # name and file path must be correct (Visual inspection)        
        puts "Struct Name:   " +c.name
        puts "Struct Base Name:   " +c.basename
        puts "File Location:   " +c.path              
    } 
  end
  
  it "should create correctly the namespaces" do 
    var=@file.namespaces
    @namespaces.push(*var)           
    @namespaces.should_not be_empty
    @namespaces.uniq.should eql @namespaces               # ... and no element should be repeated
    
    @namespaces.each{|c|
        # Class class must be correct
        c.class.should eql Doxyparser::Namespace
        # Class should have a correct parent
        c.parent.should eql nil
                  
        # name and file path must be correct (Visual inspection)        
        puts "Namepace Name:   " +c.name
        puts "Namespace Base Name:   " +c.basename
        puts "File Location:   " +c.path              
    } 
  end
  
  it "should create enums, functions and variables" do 
    var=@file.enums
    @enums.push(*var)           
    @enums.should_not be_empty
    
    var=@file.functions
    @functions.push(*var)           
    @functions.should_not be_empty
    
    var=@file.variables
    @variables.push(*var)           
    @variables.should_not be_empty
    
  end
  
  
end