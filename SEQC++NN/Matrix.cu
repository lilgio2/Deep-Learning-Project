#include "Matrix.cuh"
#include <random>

Matrix::Matrix()
{

}


Matrix::Matrix(int _numRows, int _numCols, bool isRandom)
{
	numRows = _numRows;
	numCols = _numCols;

	double r = 0.00;

	vector<double> colValues;

	for (int i = 0; i < numRows; i++)
	{

		for (int j = 0; j < numCols; j++)
		{
			if (isRandom)
			{
				r = generateRandomNumber();
			}

			colValues.push_back(r);
		}

		values.push_back(colValues);
		colValues.clear();
	}
}

double Matrix::generateRandomNumber()
{
	std::random_device rd;
	std::mt19937 gen(rd());
	std::uniform_real_distribution<> dis(0, 1);

	return dis(gen);
}

void Matrix::printToConsole()
{
	for (int i = 0; i < numRows; i++)
	{
		for (int j = 0; j < numCols; j++)
		{
			cout << this->values.at(i).at(j) << "\t\t";
		}
		cout << endl;
	}
}

Matrix Matrix::transpose()
{
	Matrix m = Matrix(numCols, numRows, false);

	for (int i = 0; i < numRows; ++i)
	{
		for (int j = 0; j < numCols; ++j)
		{
			m.setValue(j, i, getValue(i, j));
		}
	}
	return m;
}