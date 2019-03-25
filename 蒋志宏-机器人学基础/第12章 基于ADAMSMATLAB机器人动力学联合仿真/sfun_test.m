 function [sys,x0,str,ts,simStateCompliance] = sfun_test(t,x,u,flag)

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%此文件为工业机器人带动力学前馈控制的联合仿真实验用。编写日期2018/1/10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    DAStudio.error('Simulink:blocks:unhandledFlag', num2str(flag));

end



% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts,simStateCompliance]=mdlInitializeSizes

%
% call simsizes for a sizes structure, fill it in and convert it to a
% sizes array.
%
% Note that in this example, the values are hard coded.  This is not a
% recommended practice as the characteristics of the block are typically
% defined by the S-function parameters.
%
sizes = simsizes;

sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 12;   %%%%%%输出6个关节力矩，6个期望关节角度
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;    %at least one sample time is needed

sys = simsizes(sizes);


%
% initialize the initial conditions
%
x0  = [];

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0.001 0];

%%%%%%%%%%%% 关节角度初始化 end %%%%%%%%%%%%%%%
global joint_angle_begin
global joint_angle_final
global joint_torque
global joint_angle
joint_angle_begin = [0 0 0 0 0 0];
joint_angle_final = deg2rad([45 30 20 10 15 30]);
joint_torque = [0 0 0 0 0 0];
joint_angle = [0 0 0 0 0 0];
% Specify the block simStateCompliance. The allowed values are:
%    'UnknownSimState', < The default setting; warn and assume DefaultSimState
%    'DefaultSimState', < Same sim state as a built-in block
%    'HasNoSimState',   < No sim state
%    'DisallowSimState' < Error out when saving or restoring the model sim state
simStateCompliance = 'UnknownSimState';

%end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

sys = [];

%end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)
    global joint_angle_begin
    global joint_angle_final
    global joint_torque
    global joint_angle
    inter_temp{6}=zeros(1,3);
    joint_t = zeros(1,6);
    joint_v = zeros(1,6);
    joint_a = zeros(1,6);
    for i=1:1:6
        inter_temp{i} = interpolation(joint_angle_begin(i),joint_angle_final(i),5,t);
        joint_t(1,i) = inter_temp{i}(1,1);
        joint_v(1,i) = inter_temp{i}(1,2);
        joint_a(1,i) = inter_temp{i}(1,3);
    end
    joint_torque = dynamics(joint_t, joint_v, joint_a);
    joint_angle = joint_t;
    sys = [];
    
    
%end %mdlUpdate
%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
global joint_torque
global joint_angle

sys(1) = joint_torque(1);
sys(2) = joint_torque(2);
sys(3) = joint_torque(3);
sys(4) = joint_torque(4);
sys(5) = joint_torque(5);
sys(6) = joint_torque(6);

sys(7) = joint_angle(1);
sys(8) = joint_angle(2);
sys(9) = joint_angle(3);
sys(10) = joint_angle(4);
sys(11) = joint_angle(5);
sys(12) = joint_angle(6); 

%sys = [];

 %end %mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

 %end %mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

 %end %mdlTerminate

 %end
