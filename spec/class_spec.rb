require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "Doxyparser::Class" do

  before(:all) do
    @class=Doxyparser::parse_class("Ogre::UserObjectBindings",File.expand_path(__dir__+"/xml"))
    f= @class.file
    @func_filter=["UserObjectBindings", "setUserAny", "getEmptyUserAny"]
    @var_filter=["msEmptyAny", "mAttributes"]
    @enum_filter=nil
    @innerclass_filter=["Attributes"]
    @functions=[]
    @variables=[]
    @enums=[]
    @structs=[]
    @innerclasses=[]
    @file=nil
  end
  
  it "should be created consistently from name and directory" do      
      @class.path.should == __dir__+%Q{/xml/classOgre_1_1UserObjectBindings.xml}
  end
    
  it "should parse flawlessly the corresponding XML file" do    
    doc=@class.doc
    doc.class.should == Nokogiri::XML::Document
  end
  
  it "should create the correct include File" do
    @file = @class.file
    # name and file path must be correct (Visual inspection)        
    puts "Include File Name:   " +@file.name
    puts "File Location:   " +@file.path          
  end 
  
  it "should create the right inner classes according to a specified filter" do       
    @innerclasses << @class.innerclasses('protected', @innerclass_filter)
    @innerclasses.flatten!  
    @innerclasses.should_not be_empty
    @innerclasses.size.should == @innerclass_filter.size     # Should return same name of elements as the filter...
    @innerclasses.uniq.should == @innerclasses               # ... and no element should be repeated        
  end
  
  it "should create correctly the inner classes" do    
    @innerclasses.each{|c|
        # Class class must be correct
        c.class.should == Doxyparser::Class
             
        # Class should have a correct parent
        c.parent.should == @class
                  
        # name and file path must be correct (Visual inspection)        
        puts "Inner Class Name:   " +c.name
        puts "Inner Class Base Name:   " +c.basename
        puts "File Location:   " +c.path
        
        # The classes must be included in the given filter
        @innerclass_filter.should include c.basename        
    }    
  end
  
  it "should create the right methods according to a specified filter" do       
    @functions << @class.methods('public', @func_filter)
    @functions.flatten!  
    @functions.should_not be_empty       
  
    @functions.each{|f|
        # The class of the Function Node must be correct
        f.class.should == Doxyparser::Function
        
        # Functions should have a correct parent
        f.parent.should == @class
                  
        # name and .h file path must be correct (Visual inspection) # TODO Automate this
        puts "Function Name:   " +f.name
        puts "Function Base Name:   " +f.basename
        puts "Function Definition:   " +f.definition
        puts "Function Args   " +f.args
        puts "Constructor?   " +f.constructor?.to_s
        puts "Destructor?   " +f.destructor?.to_s  
        puts "Function Params:   " +f.params.join(",")
        puts "File Location:   " +f.path
        
        # The functions must be included in the given filter
       # @func_filter.should include f.name       
    }     
  end
  
    
  it "should create the right variables according to a specified filter" do       
    @variables << @class.attributes("private","static", @var_filter[0])
    @variables << @class.attributes("private")
    @variables.flatten!  
    @variables.should_not be_empty
    @variables.size.should == @var_filter.size     # Should return same name of elements as the filter...
    @variables.uniq.should == @variables               # ... and no element should be repeated       
  end
  
  it "should create correctly the variables" do    
    @variables.each{|v|
        # The class of the Function Node must be correct
        v.class.should == Doxyparser::Variable
        
        # Functions should have a correct parent
        v.parent.should == @class
                  
        # name and .h file path must be correct (Visual inspection)
        puts "Attribute Name:   " +v.name
        puts "Attribute Base Name:   " +v.basename
        puts "File Location:   " +v.path
        
        # The functions must be included in the given filter
        @var_filter.should include v.basename       
    }     
  end
  
  
end