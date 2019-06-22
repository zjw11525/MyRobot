#pragma once
#ifndef Trajplanning_h
#define Trajplanning_h
#include "Kinematic.h"
#include <iostream>
#include <math.h>
#include <vector>

using namespace std;
#define PI 3.1415926

class Trajplanning
{
public:
	Trajplanning();	
	Array MoveLine(Array pose_start, Array trans, double Velocity, double AccelerationTime, double t);
	Array CartesianMove(double PositionX, double PositionY, double PositionZ, Theta Q_Start, double Velocity, double AccelerationTime, double t, double AnglePitch = 90, double AngleYaw = 0);
	~Trajplanning();
private:
	vector<double> ScurveGen(double Start, double End, double Velocity, double Acceleration, int Num);
	double SCurveScaling(double t, double V, double A, double J, vector<double> T, double Tf);
	vector<double> SineGen(double Velocity, double AccelerationTime, int Num, double Step);
};

#endif