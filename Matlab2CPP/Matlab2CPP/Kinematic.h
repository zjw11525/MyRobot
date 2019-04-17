#pragma once
#ifndef Kinematic_h
#define Kinematic_h
#include <iostream>
#include <math.h>
#include <vector>

using namespace std;

#define PI 3.1415926

// D - H 参数
#define d1  0.28
#define d4  0.35014205
#define d6  0.0745
#define a2  0.34966093

typedef vector<vector<double>> Array;//二维double数组
typedef vector<double> Theta;


class Kinematic
{
public:
	Kinematic();
	Array Fkine_Step(Theta theta);//正解
	Theta Ikine_Step(Array T, Theta Angle_Last);//反解
	~Kinematic();
};

#endif