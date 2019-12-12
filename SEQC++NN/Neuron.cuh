#ifndef NEURON_H
#define NEURON_H

#include <iostream>
using namespace std;

class Neuron
{
public:

	//Constructor
	Neuron(double val);

	//Fast Sigmoid Activation  Call
	//f(x) = x / (1 + |x|)
	void activate();

	//FSA Derivative
	//f'(x) = f(x) * (1 - f(x))
	void derive();

	//Setters
	void setVal(double val);

	//Getters
	double getVal() { return val; }
	double getActivatedVal() { return activatedVal; }
	double getDerivedVal() { return derivedVal; }

private:

	//raw input value into neuron
	double val;
	//value after going through activation function
	double activatedVal;
	//approximate derivative value of activated value
	double derivedVal;
};

#endif