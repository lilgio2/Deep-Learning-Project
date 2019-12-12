
#include <iostream>
#include <chrono>
#include "Neuron.cuh"
#include "Matrix.cuh"
#include "NeuralNetwork.cuh"
#include <fstream>
#include <string>


using namespace std;
using namespace std::chrono;

int main(int argc, char** argv)
{
	//test neurons
	/*
	Neuron* n = new Neuron(0.9);
	cout << "Val: " << n->getVal() << endl;
	cout << "ActivatedVal: " << n->getActivatedVal() << endl;
	cout << "DerivedVal: " << n->getDerivedVal() << endl;
	*/

	//test random matrix weights creation and transposing
	/*
	Matrix* m = new Matrix(3, 2, true);
	m->printToConsole();

	cout << "--------------------------------------------------" << endl;

	Matrix* mT = m->transpose();
	mT->printToConsole();
	*/

	//test network creation with input
	/*
	vector<int> topology;
	topology.push_back(3);
	topology.push_back(2);
	topology.push_back(3);

	vector<double> input;
	input.push_back(1.0);
	input.push_back(0.0);
	input.push_back(1.0);

	NeuralNetwork* nn = new NeuralNetwork(topology);
	nn->setCurrentInput(input);

	nn->printToConsole();
	*/

	//check feedforward is calculating correctly through each layer
	/*
	vector<double> input;
	input.push_back(1);
	input.push_back(0);
	input.push_back(1);

	vector<int> topology;
	topology.push_back(3);
	topology.push_back(2);
	topology.push_back(1);

	NeuralNetwork* nn = new NeuralNetwork(topology);
	nn->setCurrentInput(input);
	nn->feedForward();
	nn->printToConsole();
	*/

	//check error calculations
	/*
	vector<double> input;
	input.push_back(1);
	input.push_back(0);
	input.push_back(1);

	vector<int> topology;
	topology.push_back(3);
	topology.push_back(2);
	topology.push_back(3);

	NeuralNetwork* nn = new NeuralNetwork(topology);
	nn->setCurrentInput(input);
	nn->setCurrentTarget(input);
	nn->feedForward();
	nn->setErrors();

	nn->printToConsole();

	cout << "Total Error: " << nn->getTotalError() << endl;
	*/

	//test backprop
	/*
	vector<double> input;
	input.push_back(1);
	input.push_back(0);
	input.push_back(1);

	vector<int> topology;
	topology.push_back(3);
	topology.push_back(2);
	topology.push_back(3);

	NeuralNetwork* nn = new NeuralNetwork(topology);
	nn->setCurrentInput(input);
	nn->setCurrentTarget(input);

	//training process
	for (int i = 0; i < 100000; ++i)
	{
		cout << "Epoch: " << i + 1 << endl;
		nn->feedForward();
		nn->setErrors();
		cout << "Total Error: " << nn->getTotalError() << endl;
		nn->backPropagation();
	}
	*/

ifstream datafile;
datafile.open("data.csv");

string fileline;
int count = 0;
int imagenumber = 0;
double num;


auto start = high_resolution_clock::now();




vector<double> input;
vector< vector<double> > inputs;
while (getline(datafile, fileline))
{
	for (int i = 0; i < fileline.size(); ++i)
	{
		if (i % 2 == 0)
		{
			num = (double)fileline[i] - 48;
			input.push_back(num);
		}
		else
		{
			continue;
		}
	}
	++count;
	if (count == 5)
	{
		inputs.push_back(input);
		input.clear();
		count = 0;
	}
}

vector<double> target;
vector< vector<double> > targets;
for (int i = 0; i < 10; ++i)
{
	target.push_back(0);
}
for (double i = 0.00; i < 10.00; i++)
{
	if (i != 0)
	{
		target[i - 1] = 0;
		target[i] = 1;
	}
	else
	{
		target[(int)i] = 1;
	}
	for (int j = 0; j < 5; ++j)
	{
		targets.push_back(target);
	}
	cout << i << endl;
}

vector<int> topology;
topology.push_back(25);
topology.push_back(23);
topology.push_back(21);
topology.push_back(19);
topology.push_back(17);
topology.push_back(15);
topology.push_back(13);
topology.push_back(11);
topology.push_back(10);


NeuralNetwork* nn = new NeuralNetwork(topology);
//nn->setCurrentInput(input);
//nn->setCurrentTarget(target);

//training process
for (int i = 0; i < 100; ++i)
{
	for (int j = 0; j < inputs.size(); ++j)
	{
		nn->setCurrentInput(inputs[j]);
		nn->setCurrentTarget(targets[j]);
		nn->feedForward();
		nn->setErrors();
		nn->backPropagation();
		if (i % 10 == 0)
		{
			cout << "----------------------------------------" << endl;
			cout << "OUTPUT " << j + 1 << ": ";
			nn->printOutputToConsole();

			cout << "TARGET " << j + 1 << ": ";
			nn->printTargetToConsole();
			cout << "----------------------------------------" << endl;
			cout << endl;
		}
	}
	//cout << "Epoch: " << i + 1 << endl;
	//nn->feedForward();
	//nn->setErrors();
	//cout << "Total Error: " << nn->getTotalError() << endl;
	//nn->backPropagation();

	//cout << "----------------------------------------" << endl;
	//cout << "OUTPUT: ";
	//nn->printOutputToConsole();

	//cout << "TARGET: ";
	//nn->printTargetToConsole();
	//cout << "----------------------------------------" << endl;
	//cout << endl;

}

//nn->printHistoricalErrors();

	delete nn;

	auto stop = high_resolution_clock::now();

	auto duration = duration_cast<microseconds>(stop - start);

	cout << "CUDA" << endl;
	cout << "Time taken by function: "
		<< duration.count() / 1000000 << " seconds" << endl;

	return 0;
}