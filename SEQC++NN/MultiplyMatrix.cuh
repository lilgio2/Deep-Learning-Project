#ifndef MULTIPLYMATRIX_H
#define MULTIPLYMATRIX_H

#include <iostream>
#include <vector>
#include <assert.h>

#include "Matrix.cuh"

using namespace std;

namespace utils
{
	//i j k matrix multiplication method
	class MultiplyMatrix
	{
	public:
		MultiplyMatrix(Matrix _a, Matrix _b);

		Matrix execute();

	private:
		Matrix a;
		Matrix b;
		Matrix c;
	};
}

#endif