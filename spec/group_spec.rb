require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyGroup" do

  before(:all) do
    @group=DoxyGroup.new(:name=> "Animation",:dir=>File.expand_path("./xml"))
    @classes=[]
    @filter=["Ogre::AnimableObject", "Ogre::Bone", "Ogre::SkeletonManager"]
  end
  
  it "should be created consistently from name and directory" do      
      @group.path.should == %Q{/home/david/workspace/ruby-doxygen-parser/spec/xml/group__Animation.xml}    
  end
   
  it "should parse flawlessly the corresponding XML file" do    
    doc=@group.doc
    doc.class.should == Nokogiri::XML::Document
  end
  
  it "should create the right classes according to a specified filter" do       
    @classes.push(*@group.classes(@filter))
    @classes.each{|c|
      puts c.name
    }
    
    @classes.should_not be_empty
    @classes.size.should == @filter.size        # Should return same name of elements as the filter...
    @classes.uniq.should == @classes               # ... and no element should be repeated        
  end
  
  it "should create correctly the classes" do    
    @classes.each{|c|
        # Class must be correct
        c.class.should == DoxyClass
        
        # Class should have a correct parent
        c.parent.should == nil
        
        # name and file path must be correct (Visual inspection)        
        puts "Class Name:   " +c.name
        puts "Class Base Name:   " +c.basename
        puts "File Location:   " +c.path
  
        
        # The classes must be included in the given filter
        @filter.should include c.name     
        
    }    
  end
end