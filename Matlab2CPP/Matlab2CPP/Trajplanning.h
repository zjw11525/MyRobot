#pragma once
#ifndef Trajplanning_h
#define Trajplanning_h
#include "Kinematic.h"
#include <iostream>
#include <math.h>
#include <vector>

using namespace std;


class Trajplanning
{
public:
	Trajplanning();
	vector<double> ScurveGen(double Start, double End, double Velocity, double Acceleration, int Num);
	~Trajplanning();
private:
	double SCurveScaling(double t, double V, double A, double J, vector<double> T, double Tf);
};

#endif