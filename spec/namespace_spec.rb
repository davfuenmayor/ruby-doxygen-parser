require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyNamespace" do

  before(:all) do
    @namespace=DoxyNamespace.new(:name=> "Ogre",:dir=>File.expand_path("./xml"))
    @classes=[]
    @filter=["Ogre::Root", "Ogre::ViewPoint", "Ogre::SceneManager"]
  end
  
  it "should be created consistently from name and directory" do      
      @namespace.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/namespaceOgre.xml}    
  end
  
  it "should parse flawlessly the corresponding XML file" do    
    doc=@namespace.parse.doc
    doc.class.should == Nokogiri::XML::Document    
  end
  
  
  it "should create the right classes according to a specified filter" do       
    @classes << @namespace.get_classes(@filter)
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
        @filter.should include c.name        
    }    
  end
end