double noNsFunction(float &);

double noNsVariable;

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
	    ~MyClass(){};
	    MyClass(double * xc){};

	    virtual double virtualMethod(UnknownType *, int& ut, InnerStruct * is);

	    UnknownType2 method(InnerStruct &);

	    static publicStaticMethod(InnerClass &);
	};

	namespace MyInnerNamespace {
		class MyClass2 {
		};
		enum OuterEnum2{
			A2, B2, C2
		};
	}
}
