clear,clc
syms s;
g = 9.8;
hm =0.6;
d12 = 0.8;
d2 = 0.6;
da = 16;

h10 = 9.2 - hm; % h1 nível do tanque 1
h20 = 5.7 - hm;% h2 nível do tanque 2

Area = ((da/2)^2)*pi;
a12 = ((d12/2)^2)*pi;
a2 = ((d2/2)^2)*pi;

C1 = (-a12*sqrt(2*g*(h10-h20))) /   (Area*(h10-h20));
C2 = (a2*sqrt(2*g*h20))         /   (2*Area*h20);
C3 = (a12*sqrt(2*g*(h10-h20)))  /   (2*Area*(h10-h20));
C4 = (-a2*sqrt(2*g*h20))        /   (2*Area*h20);

%% Planta
A = [C1,C2;C3,C4];
B = [1/Area;0];
C = [0,1];
D = 0;
sys = ss(A,B,C,D)
[a,b] = ss2tf(A,B,C,D)
G = tf(a,b)

%%Controle 1
num = 1483.4*[1 0.02973 0.0002596];
den = [1 0.01797];

C1 = tf(num,den)
%% Controle 2
num2 = 15*[1  0.02264  0.0001288];
den2 = [1  0.03718  0.0003481];
C2 = tf(num2,den2)

%% Plot
sys2 = feedback(G*C2,1);
stepinfo(sys2)