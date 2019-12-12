#ifndef LAYER_H
#define LAYER_H

#include <iostream>
#include "Neuron.cuh"
#include "Matrix.cuh"
using namespace std;

class Layer
{
public:

	//Constructor
	Layer(int size);

	//set our neuron values
	void setVal(int i, double val) { neurons.at(i).setVal(val); }

	//create singular matrix of vals for each layer of neurons
	Matrix matrixifyVals();
	Matrix matrixifyActivatedVals();
	Matrix matrixifyDerivedVals();

	//setter
	void setNeurons(vector<Neuron> _neurons) { neurons = _neurons; }

	//getter
	vector<Neuron> getNeurons() { return neurons; }


private:

	//size of our vector which represents our layer
	int size;

	//vector of neurons which represents our layer
	vector<Neuron> neurons;
};

#endif