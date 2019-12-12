#include "NeuralNetwork.cuh"

NeuralNetwork::NeuralNetwork(vector<int> _topology)
{
	topology = _topology;
	topologySize = _topology.size();

	for (int i = 0; i < topology.size(); ++i)
	{
		Layer l = Layer(topology.at(i));
		layers.push_back(l);
	}

	for (int i = 0; i < topologySize - 1; ++i)
	{
		Matrix m = Matrix(topology.at(i), topology.at(i + 1), true);

		weightMatrices.push_back(m);
	}

	for (int i = 0; i < topology.at(topology.size() - 1); ++i)
	{
		errors.push_back(0.00);
	}
}

void NeuralNetwork::setCurrentInput(vector<double> _input)
{
	input = _input;

	for (int i = 0; i < input.size(); ++i)
	{
		layers.at(0).setVal(i, input.at(i));
	}

}

void NeuralNetwork::printToConsole()
{
	for (int i = 0; i < layers.size(); ++i)
	{
		cout << "LAYER: " << i << endl;

		if (i == 0)
		{
			Matrix m = layers.at(i).matrixifyVals();
			m.printToConsole();
		}
		else
		{
			Matrix m = layers.at(i).matrixifyActivatedVals();
			m.printToConsole();
		}
		cout << "--------------------------------------------------" << endl;
		if (i < layers.size() - 1)
		{
			cout << "Weight Matrix at index " << i << endl;
			getWeightMatrix(i).printToConsole();
		}
	}
}

void NeuralNetwork::feedForward()
{
	for (int i = 0; i < (layers.size() - 1); ++i)
	{
		Matrix a = getNeuronMatrix(i);

		if (i != 0)
		{
			a = getActivatedNeuronMatrix(i);
		}

		Matrix b = getWeightMatrix(i);
		Matrix c = utils::MultiplyMatrix(a, b).execute();

		for (int c_index = 0; c_index < c.getNumCols(); c_index++)
		{
			setNeuronValue(i + 1, c_index, c.getValue(0, c_index));
		}
	}
}

void NeuralNetwork::setErrors()
{
	if (target.size() == 0)
	{
		cerr << "No target for this neural network" << endl;
		assert(false);
	}

	if (target.size() != layers.at(layers.size() - 1).getNeurons().size())
	{
		cerr << "Target size is not the same as output layer size: " << layers.at(layers.size() - 1).getNeurons().size() << endl;
		assert(false);
	}

	error = 0.00;
	int outputLayerIndex = layers.size() - 1;
	vector<Neuron> outputNeurons = layers.at(outputLayerIndex).getNeurons();
	for (int i = 0; i < target.size(); i++)
	{
		//double tempErr = (outputNeurons.at(i)->getActivatedVal() - target.at(i));
		double tempErr = (outputNeurons.at(i).getActivatedVal() - target.at(i));
		errors.at(i) = tempErr;
		error += pow(tempErr, 2); //added pow to this line
	}

	error = 0.5 * error; //newaddition

	historicalErrors.push_back(error);
}

void NeuralNetwork::backPropagation()
{
	vector<Matrix> newWeights;
	Matrix gradients;


	//output layer to hidden layer
	int outputLayerIndex = layers.size() - 1;
	Matrix derivedValuesYToZ = layers.at(outputLayerIndex).matrixifyDerivedVals();
	Matrix gradientsYToZ = Matrix(1, layers.at(outputLayerIndex).getNeurons().size(), false);
	for (int i = 0; i < errors.size(); ++i)
	{
		double d = derivedValuesYToZ.getValue(0, i);
		double e = errors.at(i);
		double g = d * e;
		gradientsYToZ.setValue(0, i, g);
	}

	int lastHiddenLayerIndex = outputLayerIndex - 1;
	Layer lastHiddenLayer = layers.at(lastHiddenLayerIndex);
	Matrix weightOutputToHidden = weightMatrices.at(outputLayerIndex - 1);
	Matrix deltaOutputToHidden = utils::MultiplyMatrix(gradientsYToZ.transpose(), lastHiddenLayer.matrixifyActivatedVals()).execute().transpose();
	Matrix newWeightsOutputToHidden = Matrix(deltaOutputToHidden.getNumRows(), deltaOutputToHidden.getNumCols(), false);

	for (int r = 0; r < deltaOutputToHidden.getNumRows(); r++)
	{
		for (int c = 0; c < deltaOutputToHidden.getNumCols(); c++)
		{
			double originalWeight = weightOutputToHidden.getValue(r, c);
			double deltaWeight = deltaOutputToHidden.getValue(r, c);
			newWeightsOutputToHidden.setValue(r, c, (originalWeight - deltaWeight));
		}
	}

	newWeights.push_back(newWeightsOutputToHidden);
	gradients = Matrix(gradientsYToZ.getNumRows(), gradientsYToZ.getNumCols(), false);

	for (int r = 0; r < gradientsYToZ.getNumRows(); r++)
	{
		for (int c = 0; c < gradientsYToZ.getNumCols(); c++)
		{
			gradients.setValue(r, c, gradientsYToZ.getValue(r, c));
		}
	}

	//last hidden to input layer
	for (int i = outputLayerIndex - 1; i > 0; --i)
	{
		Layer l = layers.at(i);
		Matrix derivedHidden = l.matrixifyDerivedVals();
		Matrix derivedGradients = Matrix(1, l.getNeurons().size(), false);
		Matrix weightMatrix = weightMatrices.at(i);
		Matrix activatedHidden = l.matrixifyActivatedVals();
		Matrix originalWeight = weightMatrices.at(i - 1);

		for (int r = 0; r < weightMatrix.getNumRows(); r++)
		{
			double sum = 0.00;
			for (int c = 0; c < weightMatrix.getNumCols(); c++)
			{
				double p = gradients.getValue(0, c) * weightMatrix.getValue(r, c);
				sum += p;
			}

			double g = sum * activatedHidden.getValue(0, r);
			derivedGradients.setValue(0, r, g);
		}

		Matrix leftNeurons = (i - 1) == 0 ? layers.at(0).matrixifyVals() : layers.at(i - 1).matrixifyActivatedVals();

		Matrix deltaWeights = utils::MultiplyMatrix(derivedGradients.transpose(), leftNeurons).execute().transpose();

		Matrix newWeightsHidden = Matrix(deltaWeights.getNumRows(), deltaWeights.getNumCols(), false);

		for (int r = 0; r < newWeightsHidden.getNumRows(); r++)
		{
			for (int c = 0; c < newWeightsHidden.getNumCols(); c++)
			{
				double w = originalWeight.getValue(r, c);
				double d = deltaWeights.getValue(r, c);
				double n = w - d;
				newWeightsHidden.setValue(r, c, n);
			}
		}

		gradients = Matrix(derivedGradients.getNumRows(), derivedGradients.getNumCols(), false);

		for (int r = 0; r < derivedGradients.getNumRows(); r++)
		{
			for (int c = 0; c < derivedGradients.getNumCols(); c++)
			{
				gradients.setValue(r, c, derivedGradients.getValue(r, c));
			}
		}

		newWeights.push_back(newWeightsHidden);
	}

	reverse(newWeights.begin(), newWeights.end());

	weightMatrices = newWeights;

}

void NeuralNetwork::printInputToConsole()
{
	for (int i = 0; i < this->input.size(); ++i)
	{
		cout << this->input.at(i) << "\t";
	}
	cout << endl;
}

void NeuralNetwork::printOutputToConsole()
{
	int indexOfOutputLayer = layers.size() - 1;
	Matrix outputValues = layers.at(indexOfOutputLayer).matrixifyActivatedVals();
	for (int c = 0; c < outputValues.getNumCols(); c++)
	{
		cout << outputValues.getValue(0, c) << "\t";
	}
	cout << endl;
}

void NeuralNetwork::printTargetToConsole()
{
	for (int i = 0; i < this->target.size(); ++i)
	{
		cout << this->target.at(i) << "\t";
	}
	cout << endl;
}

void NeuralNetwork::printHistoricalErrors()
{
	for (int i = 0; i < this->historicalErrors.size(); ++i)
	{
		cout << this->historicalErrors.at(i);
		if (i != this->historicalErrors.size() - 1)
		{
			cout << ",";
		}
	}
	cout << endl;
}