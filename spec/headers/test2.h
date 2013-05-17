#pragma once

#include "test1.h"

using namespace MyNamespace;
class AccessorsClass {


	AccessorsClass(){};

		MyClass const& get_Prop2();
		void set_Prop2(MyClass const& obj);
		
		MyClass * GetProp3();
		void SetProp3(const MyClass *obj) const;
		
		MyClass* getNotAProp(int y);
		bool setNotAProp(MyClass *obj);
		void setAlsoNotAProp(MyClass *obj, bool d);
		
		bool isBoolProp();
		
		int isNotAProp();
		bool isAlsoNotAProp(bool d);
	    
	    MyClass* getProp();
		void setProp(MyClass *obj);

		static double* getStaticProp();	
		static void setStaticProp(double* obj);

};
