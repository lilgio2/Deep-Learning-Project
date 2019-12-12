#include "Neuron.cuh"

//Constructor
Neuron::Neuron(double _val)
{
	val = _val;
	activate();
	derive();
}

void Neuron::activate()
{
	activatedVal = val / (1 + abs(val));
}

void Neuron::derive()
{
	derivedVal = activatedVal * (1 - activatedVal);
}

void Neuron::setVal(double _val)
{
	val = _val;
	activate();
	derive();
}