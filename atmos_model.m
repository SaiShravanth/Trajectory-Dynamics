function [rho,a,temp,press] = atmos_model(H_in)

D =[...
    1       -.0065      288.15          0                   101325
    2       0           216.65          11000               22632.0400950078
    3       .001        216.65          20000               5474.87742428105
    4       .0028       228.65          32000               868.015776620216
    5       0           270.65          47000               110.90577336731
    6       -.0028      270.65          51000               66.9385281211797
    7       -.002       214.65          71000               3.9563921603966
    8       0           186.94590831019 84852.0458449057    0.373377173762337  ];

hmax = 84852.0458449057;

if (H_in > hmax)
    H_in = hmax;
end

if (H_in <= 0)
    H_in = 0.0;
end

R = 287.05287;
gamma = 1.4;
g0 = 9.80665; 
RE = 6378137; 
Bs = 1.458e-6;
S = 110.4;

K = D(:,2);	%K/m
T = D(:,3);	%K
H = D(:,4);	%m
P = D(:,5);	%Pa


Hgeop = H_in;

n1 = (Hgeop <= H(2));
n2 = (Hgeop <= H(3) & Hgeop > H(2));
n3 = (Hgeop <= H(4) & Hgeop > H(3));
n4 = (Hgeop <= H(5) & Hgeop > H(4));
n5 = (Hgeop <= H(6) & Hgeop > H(5));
n6 = (Hgeop <= H(7) & Hgeop > H(6));
n7 = (Hgeop <= H(8) & Hgeop > H(7));
n8 = (Hgeop <= hmax & Hgeop > H(8));
n9 = (Hgeop>hmax);

if any(n1(:))
    i = 1;
    TonTi = 1+K(i)*(Hgeop(n1)-H(i))/T(i);
    temp(n1) = TonTi*T(i);
    PonPi = TonTi.^(-g0/(K(i)*R));
    press(n1) = P(i)*PonPi;
end

if any(n2(:))
    i = 2;
    temp(n2) = T(i);
    PonPi = exp(-g0*(Hgeop(n2)-H(i))/(T(i)*R));
    press(n2) = P(i)*PonPi;
end

if any(n3(:))
    i = 3;
    TonTi = 1+K(i)*(Hgeop(n3)-H(i))/T(i);
    temp(n3) = TonTi*T(i);
    PonPi = TonTi.^(-g0/(K(i)*R));
    press(n3) = P(i)*PonPi;
end

if any(n4(:))
    i = 4;
    TonTi = 1+K(i)*(Hgeop(n4)-H(i))/T(i);
    temp(n4) = TonTi*T(i);
    PonPi = TonTi.^(-g0/(K(i)*R));
    press(n4) = P(i)*PonPi;
end

if any(n5(:))
    i = 5;
    temp(n5) = T(i);
    PonPi = exp(-g0*(Hgeop(n5)-H(i))/(T(i)*R));
    press(n5) = P(i)*PonPi;
end

if any(n6(:))
    i = 6 ;
    TonTi = 1+K(i)*(Hgeop(n6)-H(i))/T(i);
    temp(n6) = TonTi*T(i);
    PonPi = TonTi.^(-g0/(K(i)*R));
    press(n6) = P(i)*PonPi;
end

if any(n7(:))
    i = 7;
    TonTi = 1+K(i)*(Hgeop(n7)-H(i))/T(i);
    temp(n7) = TonTi*T(i);
    PonPi = TonTi.^(-g0/(K(i)*R));
    press(n7) = P(i)*PonPi;
end

if any(n8(:))
    i = 8;
    temp(n8) = T(i);
    PonPi = exp(-g0*(Hgeop(n8)-H(i))/(T(i)*R));
    press(n8) = P(i)*PonPi;
end

if any(n9(:))
    warning('One or more altitudes above upper limit.')
    temp(n9) = NaN;
    press(n9) = NaN;
end

rho = press./temp/R;
a = sqrt(gamma * R * temp);
