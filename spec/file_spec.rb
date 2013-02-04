require 'rubygems'
require 'rspec'
require 'ruby-doxygen-parser'

describe "DoxyFile" do

  before(:all) do
    @file=DoxyFile.new(:name=> "OgreUserObjectBindings.h",:dir=>File.expand_path("./xml"))
    
    @innerclass_filter=["Attributes"]
    
    @innerclasses=[]
    
  end
  
  
end