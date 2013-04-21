require 'rubygems'
require 'rspec'
require 'doxyparser'

describe "Doxyparser::Class" do

  before(:all) do
    @class=Doxyparser::Class.new(:name=> "MyNamespace::MyClass",:dir=>File.expand_path(__dir__+"/xml"))
    @innerenums=[]
    @innerstructs=[]
    @innerclasses=[]
    @file=nil
  end

  it "should create correctly the inner structs" do
    @innerstructs << @class.innerstructs
    @innerstructs.flatten!
    @innerstructs.should_not be_empty
    @innerstructs.uniq.should eql @innerstructs# ... and no element should be
    # repeated
    @innerstructs.each{|s|
    # Class class must be correct
      s.class.should eql Doxyparser::Struct

      # Class should have a correct parent
      s.parent.should eql @class

      # XML File path must be correct
      s.path.should eql __dir__+%Q{/xml/#{s.refid}.xml}

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
    @innerenums.uniq.should eql @innerenums# ... and no element should be
    # repeated
    @innerenums.each{|e|
    # Class class must be correct
      e.class.should eql Doxyparser::Enum

      # Class should have a correct parent
      e.parent.should eql @class

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
    @innerclasses.uniq.should eql @innerclasses# ... and no element should be
    # repeated
    @innerclasses.each{|c|
    # Class class must be correct
      c.class.should eql Doxyparser::Class

      # Class should have a correct parent
      c.parent.should eql @class

      # XML File path must be correct
      c.path.should eql __dir__+%Q{/xml/#{c.refid}.xml}

      # Inner Class XML should parse without problems
      c.methods.should_not be_empty
      c.attributes.should_not be_empty

      # name and file path must be correct (Visual inspection)
      puts "Inner Class Name:   " +c.name
      puts "Inner Class Base Name:   " +c.basename
      puts "File Location:   " +c.path

    }
  end

  it "should create methods" do

    @class.methods.each {|f|
      puts "Function Params:"
      f.params.each { |param|
        puts param.type + ' ' + param.decl_name
      }
    }
  end

end