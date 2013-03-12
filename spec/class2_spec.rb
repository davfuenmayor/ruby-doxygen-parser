require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "DoxyClass" do

  before(:all) do
    @class=DoxyClass.new(:name=> "MyNamespace::MyClass",:dir=>File.expand_path(__dir__+"/xml"))
    @innerenums=[]
    @innerstructs=[]
    @innerclasses=[]
    @file=nil
  end
    
  it "should create correctly the inner structs" do
    @innerstructs << @class.innerstructs
    @innerstructs.flatten!  
    @innerstructs.should_not be_empty
    @innerstructs.uniq.should == @innerstructs               # ... and no element should be repeated   
    @innerstructs.each{|s|
        # Class class must be correct
        s.class.should == DoxyStruct       
             
        # Class should have a correct parent
        s.parent.should == @class
                  
        # XML File path must be correct
        s.path.should == __dir__+%Q{/xml/#{s.refid}.xml}
        
        # name and .h file path must be correct (Visual inspection)        
        puts "Struct Name:   " +s.name
        puts "Struct Base Name:   " +s.basename
        puts "File Location:   " +s.path          
    }    
  end
   
  it "should create correctly the inner enums" do
    @innerenums << @class.innerenums
    @innerenums.flatten!  
    @innerenums.should_not be_empty
    @innerenums.uniq.should == @innerenums               # ... and no element should be repeated   
    @innerenums.each{|e|
        # Class class must be correct
        e.class.should == DoxyEnum       
             
        # Class should have a correct parent
        e.parent.should == @class
                  
                
        # name and .h file path must be correct (Visual inspection)        
        puts "Enum Name:   " +e.name
        puts "Enum Base Name:   " +e.basename
        puts "File Location:   " +e.location
        puts "Enum Values:   " +e.values.join(", ")
        puts "Enum  Definition:   " +e.definition         
    }    
  end
  
  it "should create correctly the inner classes" do
    @innerclasses << @class.innerclasses
    @innerclasses.flatten!  
    @innerclasses.should_not be_empty
    @innerclasses.uniq.should == @innerclasses               # ... and no element should be repeated          
    @innerclasses.each{|c|
        # Class class must be correct
        c.class.should == DoxyClass        
             
        # Class should have a correct parent
        c.parent.should == @class
        
        # XML File path must be correct
        c.path.should == __dir__+%Q{/xml/#{c.refid}.xml}
        
        # Inner Class XML should parse without problems
        c.methods.should_not be_empty
        c.attributes.should_not be_empty 
                  
        # name and file path must be correct (Visual inspection)        
        puts "Inner Class Name:   " +c.name
        puts "Inner Class Base Name:   " +c.basename
        puts "File Location:   " +c.path
           
    }    
  end
  
end