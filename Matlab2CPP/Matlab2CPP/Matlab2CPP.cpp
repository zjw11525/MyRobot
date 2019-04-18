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


	double angle[6] = { 0,0,0,0,90,0 };

	for (int i = 0; i < 6; i++) angle[i] *= (PI / 180.0);
	Theta Angle_Now(angle, angle + 6);
	Theta Angle_Last(angle, angle + 6);
	Angle_Last[1] = Angle_Last[1] + PI / 2;

	Array T;

	Theta angleout(6, 0);

	T = kine.Fkine_Step(Angle_Now);
	Array T1(T);
	T1[0][3] = 0.2;
	T1[1][3] = 0.2;
	T1[2][3] = -0.3;

	Array Pos = traj.MoveLine(T, T1, 0.2, 0.1, 0.001);

for(int j = 0;j<10;j++){
	LARGE_INTEGER t1, t2, tc;
	QueryPerformanceFrequency(&tc);
	QueryPerformanceCounter(&t1);

	//traj.MoveLine(T, T1, 0.2, 0.1, 0.001);
	//Array Angleout(size(Pos[0]),vector<double>(6,0));
	for (int i = 0; i < 1000; i++)
	{
	//	T1[0][3] = Pos[0][i];
	//	T1[1][3] = Pos[1][i];
	//	T1[2][3] = Pos[2][i];
		angleout = kine.Ikine_Step(T1, Angle_Last);
	//	Angleout[i] = angleout;
	}


	QueryPerformanceCounter(&t2);
	//for (int i = 0; i < size(Pos[0]); i++)
	//{
	//	cout << Pos[0][i] << ",  " << Pos[1][i] << ",  " << Pos[2][i] << endl;
	//}
	printf("\n  Total Time:%f ms\n", \
		(t2.QuadPart - t1.QuadPart)*1000.0 / tc.QuadPart);
}
	//cout << size(Pos[0]);

	/*for (int i = 0; i < 4; i++)
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
	}*/
}
	//vector<int> a(2, 1);//a(有2个int,所有int的初值)
	//vector<vector<int>> array(2,vector<int>(2,1));//array(有2个vector,vector中初值是vector<int>(2,1))

	//cout << array.size() << endl;

	//double B = 0.3501;
	//double A = 0.3497;
	//double D = atan2(B, A)*180/PI;