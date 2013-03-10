require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyNamespace" do

  before(:all) do
    @namespace=DoxyNamespace.new(:name=> "Ogre",:dir=>File.expand_path("./xml"))
    @classes=[]
    @innernamespaces=[]
    @structs=[]
    @filter=["Root", "RibbonTrail", "SceneManager"]
    @str_filter=["isPodLike", "ViewPoint", "RenderablePass"]
    @inner_ns_filter=["OverlayElementCommands", "EmitterCommands"]
  end
  
  it "should be created consistently from name and directory" do      
      @namespace.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/namespaceOgre.xml}    
  end
  
  it "should parse flawlessly the corresponding XML file" do    
    doc=@namespace.doc
    doc.class.should == Nokogiri::XML::Document    
  end
  
  
  it "should create the right classes according to a specified filter" do       
    @classes << @namespace.classes(@filter)
    @classes.flatten!  
    @classes.should_not be_empty
    @classes.size.should == @filter.size        # Should return same name of elements as the filter...
    @classes.uniq.should == @classes               # ... and no element should be repeated        
  end
  
  it "should create correctly the classes" do    
    @classes.each{|c|
        # Class must be correct
        c.class.should == DoxyClass
        
        # Class should have a correct parent
        c.parent.should == @namespace
                  
        # XML File path must be correct
        c.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/#{c.refid}.xml}
        
        # The classes must be included in the given filter
        @filter.should include c.basename   
        
        # name and .h file path must be correct (Visual inspection)        
        puts "Class Name:   " +c.name
        puts "Class Base Name:   " +c.basename
        puts "File Location:   " +c.path      
    }    
  end
  it "should create the right structs" do       
    @structs << @namespace.structs(@str_filter)
    @structs.flatten!  
    @structs.should_not be_empty
    @structs.size.should == @str_filter.size        # Should return same name of elements as the filter...
    @structs.uniq.should == @structs               # ... and no element should be repeated        
  end
  
  it "should create correctly the structs" do    
    @structs.each{|s|
        # Class must be correct
        s.class.should == DoxyStruct
        
        # Class should have a correct parent
        s.parent.should == @namespace
                  
        # XML File path must be correct
        s.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/#{s.refid}.xml}   
        
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
    @innernamespaces.uniq.should == @innernamespaces               # ... and no element should be repeated        
  end
  
  it "should create correctly the inner namespaces" do    
    @innernamespaces.each{|s|
        # Class must be correct
        s.class.should == DoxyNamespace
        
        # Class should have a correct parent
        s.parent.should == @namespace
                  
        # XML File path must be correct
        s.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/#{s.refid}.xml}   
        
        # name and .h file path must be correct (Visual inspection)        
        puts "Namespace Name:   " +s.name
        puts "Namespace Base Name:   " +s.basename
        puts "File Location:   " +s.path   
    }    
  end
end