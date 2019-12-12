#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;


int main(int argc, const char* argv[])
{
	ifstream datafile;
	datafile.open("data.csv");
	
	string fileline;
	int count = 0;
	int imagenumber = 0;
	int num;

	vector<int> imagerow;
	vector< vector<int> > image;
	vector< vector< vector<int> > > images;
	while (getline(datafile, fileline))
	{
		for (int i = 0; i < fileline.size(); ++i)
		{
			if (i % 2 == 0)
			{
				num = (int)fileline[i] - 48;
				imagerow.push_back(num);
			}
			else
			{
				continue;
			}
		}
		image.push_back(imagerow);
		imagerow.clear();
		++count;
		if (count == 5)
		{
			images.push_back(image);
			image.clear();
			count = 0;
		}
	}

	for (int i = 0; i < images.size(); ++i)
	{
		for (int j = 0; j < images[i].size(); ++j)
		{
			for (int k = 0; k < images[i][j].size(); ++k)
			{
				cout << images[i][j][k];
			}
			cout << endl;
		}
		cout << "-----" << endl;
	}

	vector<int> filterrow1;
	vector<int> filterrow2;
	vector< vector<int> > filter1;
	vector< vector<int> > filter2;
	vector< vector<int> > filter3;
	vector< vector<int> > filter4;
	vector< vector<int> > filter5;
	vector< vector<int> > filter6;
	vector< vector<int> > filter7;
	vector< vector<int> > filter8;
	vector< vector<int> > filter9;
	vector< vector<int> > filter10;


	//Filter 1 Right Side
	filterrow1.push_back(0);
	filterrow1.push_back(1);

	filterrow2.push_back(1);
	filterrow2.push_back(0);

	filter1.push_back(filterrow1);
	filter1.push_back(filterrow1);

	//Filter 2 Left Side
	filter2.push_back(filterrow2);
	filter2.push_back(filterrow2);

	//Filter 3 Top
	filterrow1[0] = 1;	//1 1
	filterrow2[0] = 0;	//0 0

	filter3.push_back(filterrow1);
	filter3.push_back(filterrow2);

	//Filter 4 Bottom
	filter4.push_back(filterrow2);
	filter4.push_back(filterrow1);

	//Filter 5 BL Open
	//filterrow1		  1 1
	filterrow2[1] = 1;	//0 1

	filter5.push_back(filterrow1);
	filter5.push_back(filterrow2);

	//Filter 6 TL Open
	filter6.push_back(filterrow2);
	filter6.push_back(filterrow1);


	//Filter 7 BR Open
	filterrow2[0] = 1; //1 1
	filterrow2[1] = 0; //1 0

	filter7.push_back(filterrow1);
	filter7.push_back(filterrow2);

	//Filter 8 TR Open
	filter8.push_back(filterrow2);
	filter8.push_back(filterrow1);

	//Filter 9 TL BR Open
	filterrow1[0] = 0;	//0 1
	//filterrow2		  1 0

	filter9.push_back(filterrow1);
	filter9.push_back(filterrow2);

	//Filter 10 TR BL Open
	filter10.push_back(filterrow2);
	filter10.push_back(filterrow1);







}


vector< vector< vector<int> > > convolve()
{
	vector< vector< vector<int> > > convolvedImages;
	return convolvedImages;
}