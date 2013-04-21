require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "Doxyparser::Group" do

  before(:all) do
    @group=Doxyparser::Group.new(:name=> "Animation",:dir=>File.expand_path(__dir__+"/xml"))
    @classes=[]
    @filter=["Ogre::AnimableObject", "Ogre::Bone", "Ogre::SkeletonManager"]
  end
  
  it "should be created consistently from name and directory" do      
      @group.path.should eql __dir__+%Q{/xml/group__Animation.xml}
  end
   
  it "should parse flawlessly the corresponding XML file" do    
    doc=@group.doc
    doc.class.should eql Nokogiri::XML::Document
  end
  
  it "should create the right classes according to a specified filter" do       
    @classes.push(*@group.classes('public', @filter))
    @classes.each{|c|
      puts c.name
    }
    
    @classes.should_not be_empty
    @classes.size.should eql @filter.size        # Should return same name of elements as the filter...
    @classes.uniq.should eql @classes               # ... and no element should be repeated        
  end
  
  it "should create correctly the classes" do    
    @classes.each{|c|
        # Class must be correct
        c.class.should eql Doxyparser::Class
        
        # Class should have a correct parent
        c.parent.should eql nil
        
        # name and file path must be correct (Visual inspection)        
        puts "Class Name:   " +c.name
        puts "Class Base Name:   " +c.basename
        puts "File Location:   " +c.path
  
        
        # The classes must be included in the given filter
        @filter.should include c.name     
        
    }    
  end
end