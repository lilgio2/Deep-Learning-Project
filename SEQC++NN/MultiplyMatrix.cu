#include "MultiplyMatrix.cuh"
#include <math.h>

utils::MultiplyMatrix::MultiplyMatrix(Matrix _a, Matrix _b)
{
	a = _a;
	b = _b;

	if (a.getNumCols() != b.getNumRows()) {
		cerr << "A_rows: " << a.getNumRows() << " != B_cols: " << b.getNumCols() << endl;
		assert(false);
	}

	c = Matrix(a.getNumRows(), b.getNumCols(), false);
}

Matrix utils::MultiplyMatrix::execute()
{
	
	for (int i = 0; i < a.getNumRows(); ++i)
	{
		for (int j = 0; j < b.getNumCols(); ++j)
		{
			for (int k = 0; k < b.getNumRows(); ++k)
			{
				double p = a.getValue(i, k) * b.getValue(k, j);
				double newVal = c.getValue(i, j) + p;
				c.setValue(i, j, newVal);
			}
		}
	}
	
	return c;
}



