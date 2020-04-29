clc
clear; close all;
s = tf('s');

Gp = 6705.1/(s^2-4355.3);

sys = feedback(Gp,1);

G = 6705.1*s/(s^2+2349.8);
%% Design of KD_bar
figure(11)
rlocus(G)
%% After choosing KD_bar
KD_bar = 0.0144;
figure(12)
C1 = (1+KD_bar*s);
step( feedback(C1*Gp,1))
stepinfo( feedback(C1*Gp,1))
sys=feedback(C1*Gp,1)
zero(sys)
%%
z = [0.01,0.1,3,15,50,100];
figure(13)
for i = 1:6
   Gtest = C1*Gp/s*(s+z(i))
   subplot(2,3,i)
   rlocus(Gtest)
   title(sprintf('zero at %d',-z(i)))
    
end

%% PI Design zero location s = -3

G2 = C1*Gp/s*(s+3)
t=0:0.01:3;
figure(14)
rlocus(G2)
kp_bar=1.04
figure(15)
clf
sys_2=feedback(G2*kp_bar,1);
step(sys_2,t)
[y,t]=step(sys_2,t)


stepinfo(sys_2)
sserror=100*(y(end)-1);

%% Precompensator Design
kprecomp=3/20;
num=[1 20];
den=poly([-3]);
G=tf(num,den)
Gprecomp=kprecomp*G;
sys_overall=Gprecomp*sys_2;
figure(16)
step(sys_overall,t)
[y1,t]=step(sys_overall,t)

stepinfo(sys_overall)
sserror_overall=100*(y1(end)-1);