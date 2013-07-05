#pragma once

#include <stdlib.h>
#include <vector>
#include <list>
#include <map>
#include <iostream>
#include <list>
#include "test3.h"
#include "subdir/test1.h"

double noNsFunction(float& f);

double noNsVariable;

typedef double* noNsTypedef;

enum noNsEnum{
	WW, XX, ZZ
};

struct noNsStruct{
 	noNsEnum zz;
 	int yy;
};

class noNsClass {
  public:
    static double publicStaticField1;
    noNsClass(){};
    ~noNsClass(){};
};



namespace MyNamespace {

using namespace std;
class MyClass;
	
enum OuterEnum{
	AA, BB, CC
};

enum {
	value1, value2, value3
};

struct OuterStruct{
 	OuterEnum aa;
 	int bb;
};

namespace MyInnerNamespace {

	MyClass function1(noNsClass &);

	namespace MyMostInnerNamespace {		
			
		class MyClass {
			MyClass(OuterStruct&){};
		};
	
		enum MyEnum{
			A2, B2, C2
		};
	}
}


typedef MyNamespace::MyInnerNamespace::MyMostInnerNamespace::MyClass MyMostInnerClass;

OuterStruct function1(float &);

void * function2(float &);

int * function3(float &);

int globalVariable;

template <typename TYPE, class TYPE2, int entero=5>
	class TemplateClass	{
	protected:
		typedef typename std::list<TYPE>::value_type ItemList;
		ItemList mItems;
		
	public:
		TemplateClass() {} 
		virtual ~TemplateClass() {}
		virtual std::pair<bool, TYPE> removeItem(){}
	};


class MyClass : public TemplateClass<OuterStruct *, ::noNsClass> {

	private:

		OuterStruct* privateField1;
		float privateField2;
		MyClass* privateMethod1();
		void privateMethod2(MyClass *obj);
		static void* privateStaticMethod();
		typedef std::map <MyMostInnerClass *,TemplateClass< const OuterStruct&, ::noNsClass, 8> > privateTypedef;
		
	protected:

		SubDirClass * protectedField1;
		float protectedField2;
		MyClass* protectedMethod1(privateTypedef const * const gato);
		void protectedMethod2(MyClass *obj);	

	public:
		class InnerClass;
		
		
	
		typedef std::map<unsigned short, std::vector< int* > > MapShortVectorInt;
		typedef std::vector<MapShortVectorInt&> VectorMapShortVectorInt;
		
	
	    static OuterStruct* publicStaticField1;
	    static int publicStaticMethod(InnerClass &);
	    
	    enum {
			value1, value2, value3
		};

	    enum InnerEnum{
	    	    	A, B, C
	    };

		struct InnerStruct{
			OuterStruct *a;
			char *b;
		};

		class InnerClass{
			public:
			 OuterStruct* innerClassAttr;
			 double innerClassMethod(UnknownType ut);
			 InnerClass(){};
			 ~InnerClass(){};
		};

	    MyClass(){};
	    MyClass(char * xc){};
	    ~MyClass(){};
	    
	    static double* getStaticProp();	
		static void setStaticProp(double* obj);

	    virtual double virtualMethod(UnknownType *, int& ut, MyNamespace::MyClass::InnerStruct * is);
	    MyNamespace::MyInnerNamespace::MyMostInnerNamespace::MyClass method(InnerStruct &);
	    
	    inline MyClass operator- ();
	    
	    friend MyClass operator * ( std::list<void *> myList, const MyClass& rkVector );
	    friend InnerStruct** MyNamespace::friendMethod(int &);	    
	    friend class OuterStruct;

	};	
}
