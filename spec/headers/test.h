double noNsFunction(float &);

namespace MyNamespace {

enum OuterEnum{
	AA, BB, CC
};

struct OuterStruct{
 	OuterEnum aa;
 	int bb;
};

OuterStruct function1(float &);

void function2(float &);

int * function3(float &);

int globalVariable;


class MyClass {

	private:

		float privateField1;
		float privateField2;

	public:

	    static double publicStaticField1;
	    static double publicStaticField2;

	    enum InnerEnum{
	    	    	A, B, C
	    };

		struct InnerStruct{
			OuterStruct *a;
			char *b;
		};

		class InnerClass{
			public:
			 int innerClassAttr;
			 double innerClassMethod(UnknownType ut);
		};

	    MyClass(){};
	    MyClass(double * xc){};

	    virtual double virtualMethod(UnknownType *);

	    UnknownType2 method(InnerStruct &);

	    static publicStaticMethod(InnerClass &);
	};
}
