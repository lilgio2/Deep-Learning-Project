#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include "MultiplyMatrix.cuh"
#include <math.h>
#include <cuda.h>

__global__ void matrixmult(double* a, double* b, double* c, int thicc, int nice)
{
	int i = threadIdx.x;
	int j = threadIdx.y;

	for (int x = 0; x < nice; ++x)
	{
		c[i * thicc + j] += a[i * nice + x] * b[x * thicc + j];
	}


	//rcsi
	//icsc
}

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
	// + 2 for a memory buffer
	int AArraySize = a.getNumRows() * a.getNumCols() + 2;
	int BArraySize = b.getNumRows() * b.getNumCols() + 2;
	int CArraySize = c.getNumRows() * c.getNumCols() + 2;


	double* A = new double[AArraySize];
	double* B = new double[BArraySize];
	double* C = new double[CArraySize];

	int indexcheck = 0;
	for (int i = 0; i < a.getNumRows(); ++i)
	{
		for (int j = 0; j < a.getNumCols(); ++j)
		{
			A[i * a.getNumCols() + j] = a.getValue(i, j);
		}
	}

	for (int i = 0; i < b.getNumRows(); ++i)
	{
		for (int j = 0; j < b.getNumCols(); ++j)
		{
			B[i * b.getNumCols() + j] = b.getValue(i, j);
		}
	}
	
	for (int i = 0; i < c.getNumRows(); ++i)
	{
		for (int j = 0; j < c.getNumCols(); ++j)
		{
			C[i * c.getNumCols() + j] = c.getValue(i, j);
		}
	}
	
	//BEGIN BLOCK B
	
	double* DA;
	cudaMalloc((void **) &DA, sizeof(double) * AArraySize);
	
	double* DB;
	cudaMalloc((void**) &DB, sizeof(double) * BArraySize);
	
	double* DC;
	cudaMalloc((void**) &DC, sizeof(double) * CArraySize);

	cudaMemcpy(DA, A, sizeof(double) * AArraySize, cudaMemcpyHostToDevice);
	cudaMemcpy(DB, B, sizeof(double) * BArraySize, cudaMemcpyHostToDevice);
	cudaMemcpy(DC, C, sizeof(double) * CArraySize, cudaMemcpyHostToDevice);
	
	dim3 dimGrid(1, 1);
	dim3 dimBlock(a.getNumRows(), b.getNumCols());
	int thicc = b.getNumCols();
	int nice = b.getNumRows();
	
	matrixmult<<<dimGrid, dimBlock >>>(DA, DB, DC, thicc, nice);

	cudaMemcpy(C, DC, sizeof(double) * CArraySize, cudaMemcpyDeviceToHost);

	for (int i = 0; i < c.getNumRows(); ++i)
	{
		for (int j = 0; j < c.getNumCols(); ++j)
		{
			c.setValue(i,j, C[i * c.getNumCols() + j]);
		}
	}	
	
	cudaFree(DA);
	cudaFree(DB);
	cudaFree(DC);

	delete[] A;
	delete[] B;
	delete[] C;

	return c;
}



