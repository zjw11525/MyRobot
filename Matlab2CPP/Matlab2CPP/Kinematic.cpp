#include "Kinematic.h"
#include "pch.h"
//构造
Kinematic::Kinematic() {}
//析构
Kinematic::~Kinematic()
{
	//cout << "Deleting Kinematic object..." << endl;
}

Array Kinematic::Fkine_Step(Theta theta)
{
	double Theta1 = theta[0];
	double Theta2 = theta[1] - 1.5708; //offset
	double Theta3 = theta[2];
	double Theta4 = theta[3];
	double Theta5 = theta[4];
	double Theta6 = theta[5];

	Array T(4, vector<double>(4, 0));

	//计算三角函数
	double s1 = sin(Theta1);
	double c1 = cos(Theta1);

	double s2 = sin(Theta2);
	double c2 = cos(Theta2);

	double Theta23 = Theta2 + Theta3;

	double s23 = sin(Theta23);
	double c23 = cos(Theta23);

	double s4 = sin(Theta4);
	double c4 = cos(Theta4);

	double s5 = sin(Theta5);
	double c5 = cos(Theta5);

	double s6 = sin(Theta6);
	double c6 = cos(Theta6);


	double a = c23 * (c4*c5*c6 - s4 * s6) - s23 * s5*c6;
	double b = c23 * (-c4 * c5*s6 - s4 * c6) + s23 * s5*s6;
	double c = -c23 * c4*s5 - s23 * c5;
	double d = -c23 * c4*s5*d6 - s23 * (c5*d6 + d4) + a2 * c2;
	double e = s23 * (c4*c5*c6 - s4 * s6) + c23 * s5*c6;
	double f = s23 * (-c4 * c5*s6 - s4 * c6) - c23 * s5*s6;
	double g = -s23 * c4*s5 + c23 * c5;
	double h = -s23 * c4*s5*d6 + c23 * (c5*d6 + d4) + a2 * s2;
	double i = -s4 * c5*c6 - c4 * s6;
	double j = s4 * c5*s6 - c4 * c6;
	double k = s4 * s5;
	double l = s4 * s5*d6;


	T[0][0] = c1 * a - s1 * i;
	T[0][1] = c1 * b - s1 * j;
	T[0][2] = c1 * c - s1 * k;
	T[0][3] = c1 * d - s1 * l;
	T[1][0] = s1 * a + c1 * i;
	T[1][1] = s1 * b + c1 * j;
	T[1][2] = s1 * c + c1 * k;
	T[1][3] = s1 * d + c1 * l;
	T[2][0] = -e;
	T[2][1] = -f;
	T[2][2] = -g;
	T[2][3] = -h + d1;
	T[3][0] = 0;
	T[3][1] = 0;
	T[3][2] = 0;
	T[3][3] = 1;

	return T;
}

Theta Kinematic::Ikine_Step(Array T, Theta Angle_Last)
{
	double nx = T[0][0];
	double ny = T[1][0];
	double nz = T[2][0];
	double ox = T[0][1];
	double oy = T[1][1];
	double oz = T[2][1];
	double ax = T[0][2];
	double ay = T[1][2];
	double az = T[2][2];
	double px = T[0][3];
	double py = T[1][3];
	double pz = T[2][3];

	int n = 0;
	Array Angle(8, vector<double>(6, 0));
	Theta Angle_Best(6, 0);
	double angle1 = 0, angle2 = 0, angle3 = 0, angle4 = 0, angle5 = 0, angle6 = 0;

	double s3 = -(pow((px - d6 * ax), 2) + pow((py - d6 * ay), 2) + pow((pz - d6 * az - d1), 2) - pow(a2, 2) - pow(d4, 2)) / (2 * a2 * d4);
	angle3 = asin(s3);
	double c3 = cos(angle3);
	double A = a2 - d4 * s3;
	double B = d4 * c3;
	double C = d1 - pz + d6 * az;
	double D = atan2(B, A);
	double c1 = 0, c2 = 0;
	double s1 = 0, s5 = 0;
	double c23 = 0, s23 = 0;
	double ax36 = 0, ay36 = 0, az36 = 0;
	double ox36 = 0, oy36 = 0, oz36 = 0;
	double nz36 = 0;
	double error = 0, error_min = 0;
	int j = 0;

	for (int r1 = 1; r1 < 3; r1++) // loop1
	{
		if (r1 == 1)
			angle3 = asin(s3);
		else
			angle3 = PI - angle3;

		for (int r2 = 1; r2 < 3; r2++) //loop2
		{
			if (r2 == 1)
				angle2 = asin(C / (sqrt(pow(A, 2) + pow(B, 2)))) - D;
			else
				angle2 = PI - asin(C / (sqrt(pow(A, 2) + pow(B, 2)))) - D;

			c2 = cos(angle2);
			s23 = sin(angle2 + angle3);
			angle1 = atan2((py - d6 * ay)*(a2*c2 - d4 * s23), (px - d6 * ax)*(a2*c2 - d4 * s23));
			for (int r3 = 1; r3 < 3; r3++) // loop3
			{
				c1 = cos(angle1);
				s1 = sin(angle1);
				c23 = cos(angle2 + angle3);
				ax36 = ax * c1*c23 - az * s23 + ay * c23*s1;
				ay36 = ax * s1 - ay * c1;
				az36 = -az * c23 - ax * c1*s23 - ay * s1*s23;
				ox36 = c1 * c23*ox - oz * s23 + c23 * oy*s1;
				oy36 = ox * s1 - c1 * oy;
				oz36 = -c23 * oz - c1 * ox*s23 - oy * s1*s23;
				nz36 = -c23 * nz - c1 * nx*s23 - ny * s1*s23;

				if (r3 == 1)
					angle5 = acos(az36);
				else
					angle5 = -angle5;

				s5 = sin(angle5);

				if ((1 - az36) < 1e-10)
				{
					angle5 = 0;
					angle4 = 0;
					angle6 = atan2(-ox36, oy36);
				}
				else if ((1 + az36) < 1e-10)
				{
					angle5 = PI;
					angle4 = 0;
					angle6 = -atan2(-ox36, oy36);
				}
				else
				{
					angle4 = atan2(-ay36 * s5, -ax36 * s5);
					angle6 = atan2(-oz36 * s5, nz36*s5);
				}

				Angle[n][0] = angle1;
				Angle[n][1] = angle2;
				Angle[n][2] = angle3;
				Angle[n][3] = angle4;
				Angle[n][4] = angle5;
				Angle[n][5] = angle6;

				n = n + 1;
			}
		}
	}

	if (n == 0)
		return Angle_Best;
	else
		for (int i = 0; i < n; i++)
		{
			/*	error = abs(Angle[i][0] - Angle_Last[0]) / 5.9341 + abs(Angle[i][1] - Angle_Last[1]) / 3.8397 +
					abs(Angle[i][2] - Angle_Last[2]) / 4.5379 + abs(Angle[i][3] - Angle_Last[3]) / 6.2832 +
					abs(Angle[i][4] - Angle_Last[4]) / 4.3633 + abs(Angle[i][5] - Angle_Last[5]) / 6.2832;*/
			error = abs(Angle[i][0] - Angle_Last[0]) * 0.1685 + abs(Angle[i][1] - (Angle_Last[1] - 1.5708)) * 0.2604 +
				abs(Angle[i][2] - Angle_Last[2]) * 0.2204 + abs(Angle[i][3] - Angle_Last[3]) * 0.1592 +
				abs(Angle[i][4] - Angle_Last[4]) * 0.2292 + abs(Angle[i][5] - Angle_Last[5]) * 0.1592;
			if (i == 0)
			{
				error_min = error;
				j = i;
			}
			else if (error < error_min)
			{
				error_min = error;
				j = i;
			}
		}
	Angle_Best = Angle[j];
	Angle_Best[1] = Angle_Best[1] + 1.5708;
	return Angle_Best;
}