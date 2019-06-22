#include "Trajplanning.h"
#include "pch.h"

//构造
Trajplanning::Trajplanning() {}
//析构
Trajplanning::~Trajplanning()
{
	//cout << "Deleting Trajplanning object..." << endl;
}

vector<double> Trajplanning::SineGen(double Velocity, double AccelerationTime, int Num, double Step)
{
	if (AccelerationTime / Step * 2 > Num)
		AccelerationTime = Num / 2 * Step; //约束
	
	double Acceleration = Velocity / (2 * AccelerationTime / Step);

	double t1 = ceil(AccelerationTime / Step); //acceleration
	double t2 = ceil(Num - t1); //deceleration

	double w1 = Acceleration * t1 * t1;//加速段位移
	double w2 = Velocity * (t2 - t1); //减速段位移
	double all = 2 * w1 + w2; //总位移
	
	vector<double> s(Num, 0);
	double s1 = 0;
	double s2 = 0;

	for (int t = 0; t < Num; t++) 
	{
		if (t <= t1) 
		{
			s[t] = Acceleration * (t - sin(t / t1 * PI) * t1 / PI) * t1 / all; // % w = 1 / t1
			s1 = s[t];
			s2 = s1;		
		}
	
		if ((t > t1) && (t <= t2)) 
		{
			s[t] = s1 + Velocity * (t - t1) / all;
			s2 = s[t];		
		}


		if (t > t2) 
		{
			s[t] = s2 + Acceleration * ((t - t2) + sin((t - t2) / t1 * PI) * t1 / PI) * t1 / all;
		}
	}

	return s;
}

vector<double> Trajplanning::ScurveGen(double Start, double End, double Velocity, double Acceleration, int Num)
{
	int N = Num;

	double ThetaStart = Start;
	double ThetaEnd = End;
	double VTheta = Velocity;
	double ATheta = Acceleration;
	double Tf = 1.8;

	double v = abs(VTheta / (ThetaEnd - ThetaStart));
	double a = abs(ATheta / (ThetaEnd - ThetaStart));

	vector<double> theta(N, 0);
	vector<double> s(N, 0);


	vector<double> T(7, 0);
	double V = 0;
	double A = 0;
	double J = 0;
	double TF = 0;
	for (int i = 0; i < 1000; i++)
	{
		J = (pow(a, 2) * v) / (Tf*v*a - pow(v, 2) - a);
		T[0] = a / J;
		T[1] = v / a - a / J; // t2 = v / a - t1;
		T[2] = T[0];
		T[3] = Tf - 2 * a / J - 2 * v / a;    // t4 = Tf - 4 * t1 - 2 * t2;
		T[4] = T[2];
		T[5] = T[1];
		T[6] = T[0];
		if (T[1] < -1e-6)
			a = sqrt(v*J);
		else if (T[3] < -1e-6)
			v = Tf * a / 2 - a * a / J;
		else if (J < -1e-6)
			Tf = (pow(v, 2) + a) / (v*a) + 1e-1;
		else break;
	}
	A = a;
	V = v;
	TF = Tf;

	vector<double> t(N, 0);
	int  j = 0;
	double count = 0;
	for (count = 0; count < TF; count += (TF / (N - 1)))	//t = linspace(0, TF, N);
		t[j++] = count;
	t[N - 1] = TF;

	for (int i = 0; i < N; i++)
	{
		if (i == N)
			a = a;

		s[i] = SCurveScaling(t[i], V, A, J, T, TF);
		theta[i] = ThetaStart + s[i] * (ThetaEnd - ThetaStart);
	}
	return theta;
}

double Trajplanning::SCurveScaling(double t, double V, double A, double J, vector<double> T, double Tf)
{
	double dt = 0;
	double s = 0;
	double t_temp = 0;

	if ((t >= 0) && (t <= T[0]))
		s = 1 / 6 * J * pow(t, 3);
	else if ((t > T[0]) && t <= (T[0] + T[1]))
	{
		dt = t - T[0];
		s = 0.5 * A * pow(dt, 2) + pow(A, 2) / (2 * J) * dt + pow(A, 3) / (6 * pow(J, 2));
	}
	else if (t > (T[0] + T[1]) && t <= (T[0] + T[1] + T[2]))
	{
		dt = t - T[0] - T[1];
		s = -0.1667 * J*pow(dt, 3) + 0.5 * A*pow(dt, 2) + (A*T[1] + pow(A, 2) / (2 * J))*dt
			+ 0.5 * A*pow(T[1], 2) + pow(A, 2) / (2 * J)*T[1] + pow(A, 3) / (6 * pow(J, 2));
	}
	else if (t > (T[0] + T[1] + T[2]) && t <= (T[0] + T[1] + T[2] + T[3]))
	{
		dt = t - T[0] - T[1] - T[2];
		s = V * dt + (-0.1667 * J*pow(T[2], 3)) + 0.5 * A*pow(T[2], 2) + (A*T[1] + pow(A, 2) / (2 * J))*T[2]
			+ 0.5 * A*pow(T[1], 2) + pow(A, 2) / (2 * J)*T[1] + pow(A, 3) / (6 * pow(J, 2));
	}
	else if (t > (T[0] + T[1] + T[2] + T[3]) && t <= (T[0] + T[1] + T[2] + T[3] + T[4]))
	{
		t_temp = Tf - t;
		dt = t_temp - T[0] - T[1];
		s = -0.1667 * J*pow(dt, 3) + 0.5 * A*pow(dt, 2) + (A*T[1] + pow(A, 2) / (2 * J))*dt
			+ 0.5 * A*pow(T[1], 2) + pow(A, 2) / (2 * J)*T[1] + pow(A, 3) / (6 * pow(J, 2));
		s = 1 - s;
	}
	else if (t > (T[0] + T[1] + T[2] + T[3] + T[4]) && t <= (T[0] + T[1] + T[2] + T[3] + T[4] + T[5])) 
	{
		t_temp = Tf - t;
		dt = t_temp - T[0];
		s = 0.5 * A * pow(dt, 2) + pow(A, 2) / (2 * J) * dt + pow(A, 3) / (6 * pow(J, 2));
		s = 1 - s;	
	}
	else if (t > (T[0] + T[1] + T[2] + T[3] + T[4] + T[5]) && t <= (T[0] + T[1] + T[2] + T[3] + T[4] + T[5] + T[6] + 1e5)) 
	{
		t_temp = Tf - t;
		s = 0.1667 * J * pow(t_temp, 3);
		s = 1 - s;	
	}
	return s;
}

Array Trajplanning::MoveLine(Array pose_start, Array trans, double Velocity, double AccelerationTime, double t) 
{
	double transx = trans[0][3];
	double transy = trans[1][3];
	double transz = trans[2][3];
	double L = sqrt(pow(transx, 2) + pow(transy, 2) + pow(transz, 2));//运动距离
	int N = ceil(L / (Velocity*t));//计算插补数量

	//vector<double> s = ScurveGen(0, 1, Velocity, Acceleration, N);
	vector<double> s = SineGen(Velocity, AccelerationTime, N, t);
	Array Position(3, vector<double>(N, 0));

	for (int i = 0; i < N; i++) 
	{
		Position[0][i] = pose_start[0][3] + transx * s[i];
		Position[1][i] = pose_start[1][3] + transy * s[i];
		Position[2][i] = pose_start[2][3] + transz * s[i];
	}
	return Position;
}

Array Trajplanning::CartesianMove(double PositionX, double PositionY, double PositionZ, Theta Q_Start, double Velocity, double AccelerationTime, double t, double AnglePitch, double AngleYaw)
{
	Kinematic kine;//new一个对象
	double q_zero[6] = { 0, 0, 0, 0, 90, 0 };
	q_zero[4] = AnglePitch;
	q_zero[5] = AngleYaw;
	for (int i = 0; i < 6; i++) q_zero[i] *= (PI / 180.0);

	Theta Q_zero(q_zero,q_zero+6); //底座->抓手
	Theta Angle_Last = Q_zero;

	Array pose_start = kine.Fkine_Step(Q_zero); //正解
	Array pose_end = pose_start;
	//位置
	pose_end[0][3] = PositionX;//0.3;
	pose_end[1][3] = PositionY;//-0.5;
	pose_end[2][3] = PositionZ;//0.2;
	double xtrans = pose_end[0][3] - pose_start[0][3];
	double ytrans = pose_end[1][3] - pose_start[1][3];
	double ztrans = pose_end[2][3] - pose_start[2][3];

	Theta Q_End = kine.Ikine_Step(pose_end, Q_zero);
	for (int i = 0; i < 6; i++) Q_End[i] *= (180.0 / PI);

	double L = sqrt(pow(xtrans,2) + pow(ytrans,2) + pow(ztrans,2)); //distance
	int N = ceil(L / (Velocity * t));//计算插补数量
	vector<double> s = SineGen(Velocity, AccelerationTime, N, t);;

	Array qout(6, vector<double>(N, 0));

	for (int i = 0; i < N; i++) 
	{
		qout[0][i] = Q_Start[0] + (Q_End[0] - Q_Start[0]) * s[i];
		qout[1][i] = Q_Start[1] + (Q_End[1] - Q_Start[1]) * s[i];
		qout[2][i] = Q_Start[2] + (Q_End[2] - Q_Start[2]) * s[i];
		qout[3][i] = Q_Start[3] + (Q_End[3] - Q_Start[3]) * s[i];
		qout[4][i] = Q_Start[4] + (Q_End[4] - Q_Start[4]) * s[i];
		qout[5][i] = Q_Start[5] + (Q_End[5] - Q_Start[5]) * s[i];
	}

	return qout;
}