#include "Layer.cuh"

Layer::Layer(int size)
{
	this->size = size;

	for (int i = 0; i < size; ++i)
	{
		Neuron n = Neuron(0.00);
		neurons.push_back(n);
	}
}

Matrix Layer::matrixifyVals()
{
	Matrix m = Matrix(1, neurons.size(), false);
	for (int i = 0; i < neurons.size(); ++i)
	{
		m.setValue(0, i, neurons.at(i).getVal());
	}
	return m;
}

Matrix Layer::matrixifyActivatedVals()
{
	Matrix m = Matrix(1, neurons.size(), false);
	for (int i = 0; i < neurons.size(); ++i)
	{
		m.setValue(0, i, neurons.at(i).getActivatedVal());
	}
	return m;
}

Matrix Layer::matrixifyDerivedVals()
{
	Matrix m = Matrix(1, neurons.size(), false);
	for (int i = 0; i < neurons.size(); ++i)
	{
		m.setValue(0, i, neurons.at(i).getDerivedVal());
	}
	return m;
}