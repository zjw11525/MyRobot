// ConsoleApplication1.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//
#include "pch.h"
#include <iostream>
#include <iomanip>
#include <Windows.h>
#include "Kinematic.h"

using namespace std;

int main()
{
	Kinematic kine;//new一个对象
	Trajplanning traj;

	vector<double> s = traj.ScurveGen(0,1,0.1,0.03,1000);

	for (int i = 0; i < 1000; i++) 
	{
		cout << s[i] << ','<<endl;
	}

	double angle[6] = { 0,0,0,0,90,0 };

	for (int i = 0; i < 6; i++) angle[i] *= (PI / 180.0);
	Theta Angle_Now(angle, angle + 6);
	Theta Angle_Last(angle, angle + 6);
	Angle_Last[1] = Angle_Last[1] + PI / 2;

	Array T;

	Theta angleout(6, 0);

	LARGE_INTEGER t1, t2, tc;
	QueryPerformanceFrequency(&tc);
	QueryPerformanceCounter(&t1);

	T = kine.Fkine_Step(Angle_Now);
	angleout = kine.Ikine_Step(T, Angle_Last);	

	QueryPerformanceCounter(&t2);
	printf("Use Time:%f\n", \
		(t2.QuadPart - t1.QuadPart)*1000.0 / tc.QuadPart);

	for (int i = 0; i < 4; i++)
	{
		for (int j = 0; j < 4; j++)
		{
			if (T[i][j] > 0 && T[i][j] < 1e-5)
				T[i][j] = 0;
			if (T[i][j] < 0 && -T[i][j] < 1e-5)
				T[i][j] = 0;
			cout << setprecision(4) << T[i][j] << "  ";
		}
		cout << endl;
	}
	cout << endl;
	for (int i = 0; i < 6; i++)
	{
		if (angleout[i] > 0 && angleout[i] < 1e-10)
			angleout[i] = 0;
		if (angleout[i] < 0 && -angleout[i] < 1e-10)
			angleout[i] = 0;
		cout << angleout[i] * 180 / PI << endl;
	}
}
	//vector<int> a(2, 1);//a(有2个int,所有int的初值)
	//vector<vector<int>> array(2,vector<int>(2,1));//array(有2个vector,vector中初值是vector<int>(2,1))

	//cout << array.size() << endl;

	//double B = 0.3501;
	//double A = 0.3497;
	//double D = atan2(B, A)*180/PI;