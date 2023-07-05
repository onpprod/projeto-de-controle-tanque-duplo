clear,clc

% Planta Linearizada
syms s;
g = 9.8;
hm = 0.6;
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

A = [C1,C2;C3,C4];
B = [1/Area;0];
C = [0,1];
D = 0;
[num,den] = ss2tf(A,B,C,D);
GL = tf(num,den)
%===============
% Controlador
Mp = 0.1;
tr = 300;
ess = 0.05;
lam = 0.591;
DesiredPM = 100*lam;
wc = (pi-acos(lam))/(tr*sqrt(1-lam^2))

Gjwc = 1.471e-05/( ((1i*wc)^2) + (0.007294*1i*wc) + 4.077e-06 )
theta = rad2deg(angle(Gjwc))
PM = theta +180 
fi = DesiredPM - theta -180
NewPM = fi + 5
a = (1 - sin(deg2rad(NewPM)))/(1 + sin(deg2rad(NewPM)))
Tal = 1/(wc*sqrt(a))
%===============
FromGraphDB = 16.9;
%===============
Kdb = 10*log10(a) +FromGraphDB
K = 10^(Kdb/20)
c1num = K*[Tal 1]
c1den = [a*Tal 1]
C1 = tf(c1num,c1den)

Kp = K/den(end)
erro = (1/(1+Kp))*100
Kp2 = (1/ess) - 1
p = -wc/20
z = (Kp2/Kp)*p
numc2 = [1 -z]
denc2 = [1 -p]
C2 = tf(numc2,denc2)
C = C1*C2