def home_dir
	File.expand_path('..', File.dirname(__FILE__))
end

def xml_dir
	home_dir + '/spec/xml'
end

def compare_members members, expected_members, clazz = Doxyparser::Function
	basename_members = members.map{|m| m.basename}.uniq.sort
	expected_members.sort!
	
	basename_members.should eql expected_members
	
	members.each{ |m|
		m.class.should eql clazz
		m.name.should be_start_with("#{@class.name}::")
		m.parent.should eql @class
		m.location.should match %r{#{home_dir}/spec/headers/test1.h:\d+}
	}
end
