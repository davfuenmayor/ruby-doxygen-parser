require 'doxyparser'



FactoryGirl.define do
  factory :Ogre, class: Doxyparser::Namespace do
  	 skip_create
    name "Ogre"
    basename  "Ogre"
    node nil
    parent nil
    path spec_dir+'/xml/namespaceOgre.xml'
  end

  factory :MyNamespace, class: Doxyparser::Namespace do
    name "MyNamespace"
    basename  "MyNamespace"
    node nil
    parent nil
    path spec_dir+'/xml/namespaceMyNamespace.xml'
  end
end
