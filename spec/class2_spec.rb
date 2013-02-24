require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyClass" do

  before(:all) do
    @class=DoxyClass.new(:name=> "example::Mula",:dir=>File.expand_path("./xml"))
    @enum_filter=nil    
    @enums=[]
    @structs=[]
    @file=nil
  end
  
  it "should be created consistently from name and directory" do      
      @class.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/classexample_1_1Mula.xml}    
  end
  
  it "should create the right inner structs according to a specified filter" do       
    @structs << @class.innerstructs
    @structs.flatten!  
    @structs.should_not be_empty
    @structs.uniq.should == @structs               # ... and no element should be repeated       
  end
  
  it "should create correctly the inner structs" do    
    @structs.each{|s|
        # Class class must be correct
        s.class.should == DoxyStruct       
             
        # Class should have a correct parent
        s.parent.should == @class
                  
        # XML File path must be correct
        s.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/#{s.refid}.xml}   
        
        # name and .h file path must be correct (Visual inspection)        
        puts "Struct Name:   " +s.name
        puts "File Location:   " +s.path          
    }    
  end
  
  it "should create the right inner enums according to a specified filter" do       
    @enums << @class.innerenums
    @enums.flatten!  
    @enums.should_not be_empty
    @enums.uniq.should == @enums               # ... and no element should be repeated       
  end
  
  it "should create correctly the inner enums" do    
    @enums.each{|e|
        # Class class must be correct
        e.class.should == DoxyEnum       
             
        # Class should have a correct parent
        e.parent.should == @class
                  
                
        # name and .h file path must be correct (Visual inspection)        
        puts "Enum Name:   " +e.name
        puts "File Location:   " +e.location
        puts "Enum Values:   " +e.values.join(", ")
        puts "Enum  Definition:   " +e.definition         
    }    
  end
  
end