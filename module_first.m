clc; close all; 

filename1='C:\Users\hp\Desktop\DRDO\data.xlsx';
location1= 'A1:F40';

k=0.01;
t = 0:40;

%Input Data Model
[t_c,m_c,theta]=readingInputAndInterpolate(filename1,location1,t);


t1= 0:41;

%initial conditions
v=1; x=0; y=50; gam=90; alpha=0; v_dot=0; gam_dot=0;

%Aw = 1100; cd = 0.0610; 

%initial atmospheric conditions
temp = zeros(1,length(t_c)+1);
pressure = zeros(1,length(t_c)+1);
density = zeros(1,length(t_c)+1);
SpeedofSound = zeros(1,length(t_c)+1);
g_h= zeros(1,length(t_c)+1);

for l=1:length(t_c)
    
    %gravity model
    g_h(l+1) = gc(y(l));

    %Atmospheric Model
    filename2 = 'C:\Users\hp\Desktop\DRDO\AtmosModel2.xlsx';
    location2 ='A1:E35';
    [temp(l+1), pressure(l+1), density(l+1), SpeedofSound(l+1)]=atmosphereModel(filename2,location2,y(l));
    
    alpha(l+1) = theta(l) - gam(l);
    
    %acceleration
    v_dot(l+1)= ((t_c(l)*cosd(alpha(l)))/m_c(l))- (g_h(l)*sind(gam(l)));
    %pitch rate
    gam_dot(l+1)= -((g_h(l)*cosd(gam(l)))/v(l))+ (t_c(l)*sind(alpha(l))/(m_c(l)*v(l)));
    %drag
    %D(l+1) = 0.5*density(l)*a(l)^2*Aw*cd;
     
    %point mass equations
    v(l+1)=v(l)+ ((t_c(l)*cosd(alpha(l)))/m_c(l))- (g_h(l)*sind(gam(l)));
    gam(l+1) = gam(l) + ((g_h(l)*cosd(gam(l)))/v(l))+ (t_c(l)*sind(alpha(l))/(m_c(l)*v(l)));
    x(l+1) = x(l) + (v(l)*cosd(gam(l)));
    y(l+1) = y(l) + (v(l)*sind(gam(l)));
    
end

figure;
subplot(3,2,1); plot(t,t_c); 
namings('Time(s)','Thrust(N)','Thrust');
subplot(3,2,2); plot(t,m_c); 
namings('Time(s)','Mass(kg)','Missile Mass');
subplot(3,2,3); plot(t1,v_dot);
namings('Time(s)','Acceleration(m/s^2)','Acceleration');
subplot(3,2,4); plot(t1,gam_dot);
namings('Time(s)','Pitch Rate(deg/s)','Pitch Rate');
subplot(3,2,5); plot(t,theta);
namings('Time(s)','Theta(deg)','Theta');
figure;
subplot(3,2,1); plot(t1,x/1000);
namings('Time(s)','Range(km)','Range');
subplot(3,2,2); plot(t1,y/1000);
namings('Time(s)','Height(km)','Height');
subplot(3,2,3); plot(x/1000,y/1000);
namings('Range(km)','Height(km)','Height vs Range');
subplot(3,2,4); plot(t1,v); 
namings('Time(s)','Velocity(m/s)','Velocity');
subplot(3,2,5); plot(t1,gam);
namings('Time(s)','Gamma(deg)','Gamma');
subplot(3,2,6); plot(t1,alpha);
namings('Time(s)','Alpha(deg)','Alpha');
figure;
subplot(3,2,1); plot(y/1000,temp);
namings('Height(km)','Temperature(k)','Temperature');
subplot(3,2,2); plot(y/1000,pressure);
namings('Height(km)','Pressure(kN/m^2)','Ambient Pressure');
subplot(3,2,3); plot(y/1000,SpeedofSound);
namings('Height(km)','Speed of Sound(m/s^2)','Speed of Sound');
subplot(3,2,4); plot(y/1000,density);
namings('Height(km)','Air Density(kg/m^3)','Air Density');
subplot(3,2,5); plot(y/1000,g_h);
namings('Height(km)','g(m/s^2)','Acceleration due to Gravity');

%converting column matrix to row matrix
v=v'; x=x'; y=y'; gam=gam';

%exporting data to excel sheet
q=table(v,x,y,gam);
filename3 = 'C:\Users\hp\Desktop\DRDO\outputs.xlsx';
location3='A1';
exportToExcel(filename3,location3,q);