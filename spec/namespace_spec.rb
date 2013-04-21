require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "Doxyparser::Namespace" do

  before(:all) do
    @namespace=Doxyparser::parse_namespace("Ogre", File.expand_path(__dir__+"/xml"))
    @classes=[]
    @innernamespaces=[]
    @structs=[]
    @filter=["Root", "RibbonTrail", "SceneManager"]
    @str_filter=["isPodLike", "ViewPoint", "RenderablePass"]
    @inner_ns_filter=["OverlayElementCommands", "EmitterCommands"]
  end
  
  it "should be created consistently from name and directory" do      
      @namespace.path.should eql __dir__+%Q{/xml/namespaceOgre.xml}
  end
  
  it "should parse flawlessly the corresponding XML file" do    
    doc=@namespace.doc
    doc.class.should eql Nokogiri::XML::Document    
  end
  
  
  it "should create the right classes according to a specified filter" do       
    @classes << @namespace.classes('public', @filter)
    @classes.flatten!  
    @classes.should_not be_empty
    @classes.size.should eql @filter.size        # Should return same name of elements as the filter...
    @classes.uniq.should eql @classes               # ... and no element should be repeated        
  end
  
  it "should create correctly the classes" do    
    @classes.each{|c|
        # Class must be correct
        c.class.should eql Doxyparser::Class
        
        # Class should have a correct parent
        c.parent.should eql @namespace
                  
        # XML File path must be correct
        c.path.should eql __dir__+%Q{/xml/#{c.refid}.xml}
        
        # The classes must be included in the given filter
        @filter.should include c.basename   
        
        # name and .h file path must be correct (Visual inspection)        
        puts "Class Name:   " +c.name
        puts "Class Base Name:   " +c.basename
        puts "File Location:   " +c.path      
    }    
  end
  it "should create the right structs" do       
    @structs << @namespace.structs('public', @str_filter)
    @structs.flatten!  
    @structs.should_not be_empty
    @structs.size.should eql @str_filter.size        # Should return same name of elements as the filter...
    @structs.uniq.should eql @structs               # ... and no element should be repeated        
  end
  
  it "should create correctly the structs" do    
    @structs.each{|s|
        # Class must be correct
        s.class.should eql Doxyparser::Struct
        
        # Class should have a correct parent
        s.parent.should eql @namespace
                  
        # XML File path must be correct
        s.path.should eql __dir__+%Q{/xml/#{s.refid}.xml}
        
        # name and .h file path must be correct (Visual inspection)        
        puts "Struct Name:   " +s.name
        puts "Struct Base Name:   " +s.basename
        puts "File Location:   " +s.path   
    }    
  end
  
  it "should create the innernamespaces" do       
    @innernamespaces << @namespace.innernamespaces(@inner_ns_filter)
    @innernamespaces.flatten!  
    @innernamespaces.should_not be_empty
    @innernamespaces.uniq.should eql @innernamespaces               # ... and no element should be repeated        
  end
  
  it "should create correctly the inner namespaces" do    
    @innernamespaces.each{|s|
        # Class must be correct
        s.class.should eql Doxyparser::Namespace
        
        # Class should have a correct parent
        s.parent.should eql @namespace
                  
        # XML File path must be correct
        s.path.should eql __dir__+%Q{/xml/#{s.refid}.xml}
        
        # name and .h file path must be correct (Visual inspection)        
        puts "Namespace Name:   " +s.name
        puts "Namespace Base Name:   " +s.basename
        puts "File Location:   " +s.path   
    }    
  end
end