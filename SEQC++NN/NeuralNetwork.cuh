#ifndef NEURALNETWORK_H
#define NEURALNETWORK_H

#include <iostream>
#include <vector>
#include <algorithm>
#include "MultiplyMatrix.cuh"
#include "Matrix.cuh"
#include "Layer.cuh"

using namespace std;

class NeuralNetwork
{
public:
	//constructor
	NeuralNetwork(vector<int> topology);

	//our inputs
	void setCurrentInput(vector<double> input);

	//our target outputs
	void setCurrentTarget(vector<double> _target) { target = _target; }

	//push input through network
	void feedForward();

	//calculate error based on target values
	void setErrors();

	//backpropagation to alter weights
	void backPropagation();

	//printers
	void printToConsole();
	void printInputToConsole();
	void printOutputToConsole();
	void printTargetToConsole();
	void printHistoricalErrors();


	//setters
	void setNeuronValue(int indexLayer, int indexNeuron, double val) { layers.at(indexLayer).setVal(indexNeuron, val); }

	//getters
	Matrix getNeuronMatrix(int index) { return layers.at(index).matrixifyVals(); }
	Matrix getActivatedNeuronMatrix(int index) { return layers.at(index).matrixifyActivatedVals(); }
	Matrix getDerivedNeuronMatrix(int index) { return layers.at(index).matrixifyDerivedVals(); }
	Matrix getWeightMatrix(int index) { return weightMatrices.at(index); }
	vector<double> getErrors() { return errors; }
	double getTotalError() { return error; }

private:
	//size of our vector for topology (how many layers we have)
	int topologySize;

	//the form of the entire neural network
	vector<int> topology;

	//each layer within the network
	vector<Layer> layers;

	//the weights for connecting layers to one another
	vector<Matrix> weightMatrices;

	//gradients from error calculations
	vector<Matrix> gradiantMatrices;

	//our input into the neural network
	vector<double> input;

	//our target response from output
	vector<double> target;

	//current error (total)
	double error;

	//each individidual error
	vector<double> errors;

	//prior errors
	vector<double> historicalErrors;
};



#endif