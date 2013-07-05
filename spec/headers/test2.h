#pragma once

#include "test1.h"

using namespace MyNamespace;
class AccessorsClass {


	AccessorsClass(){};

		MyClass const& get_Prop2get_();
		void set_Prop2set_2(MyClass const& obj);
		
		MyClass * Get3DProp3();
		void Set3DProp3(const MyClass *obj) const;
		
		MyClass* getNotAProp(int y);
		bool setNotAProp(MyClass *obj);
		void setAlsoNotAProp(MyClass *obj, bool d);
		
		bool isBoolPropis();
		
		int isNotAProp();
		bool isAlsoNotAProp(bool d);
	    
	    MyClass* getPropget();
		void setPropset(MyClass *obj);

		static double* getStaticProp();	
		static void setStaticProp(double* obj);

};
