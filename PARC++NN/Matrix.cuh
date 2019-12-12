#ifndef MATRIX_H
#define MATRIX_H

#include <iostream>
#include <vector>
using namespace std;

class Matrix
{
public:

	//Dummy Default
	Matrix();

	//Constructor
	Matrix(int numRows, int numCols, bool isRandom);

	//Matrix Transpose
	Matrix transpose();

	//Gens a random number for our weight
	double generateRandomNumber();

	//print to console
	void printToConsole();

	//Setters
	void setValue(int row, int col, double val) { values.at(row).at(col) = val; }


	//Getters
	double getValue(int row, int col) { return values.at(row).at(col); }
	int getNumRows() { return numRows; }
	int getNumCols() { return numCols; }
	vector <vector<double> > getValues() { return values; }

private:

	//number of rows in our matrix (first layer)
	int numRows;

	//number of columns in our matrix (second layer)
	int numCols;

	//all those values stored in 2d vector that simulates matrix
	vector< vector<double> > values;
};


#endif