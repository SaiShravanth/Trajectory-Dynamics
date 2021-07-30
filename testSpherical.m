clc; close all; 

filename1='C:\Users\hp\Desktop\DRDO\data.xlsx';
location1= 'A1:F700';

t = 0:700;

%Input Data Model
[t_c,m_c,theta]=readingInputAndInterpolate(filename1,location1,t);


t1= 0:701;

%initial conditions
v=1; x=0; r=50; gam=90-0.0001; alpha=0; v_dot=0; gam_dot=0;

Aw = 1100; cd = 0.0610; 
Re = 6378137;
%initial atmospheric conditions
temp = zeros(1,length(t_c)+1);
pressure = zeros(1,length(t_c)+1);
density = zeros(1,length(t_c)+1);
SpeedofSound = zeros(1,length(t_c)+1);
g_h= zeros(1,length(t_c)+1);
D =  zeros(1,length(t_c)+1);
l=0;
while(r>0)
    l=l+1;
    %gravity model
    g_h(l) = gc(r(l));

    %Atmospheric Model
    filename2 = 'C:\Users\hp\Desktop\DRDO\AtmosModel2.xlsx';
    location2 ='A1:E35';
    [temp(l), pressure(l), density(l), SpeedofSound(l)]=atmosphereModel(filename2,location2,r(l));
    
    alpha(l) = theta(l) - gam(l);
    
    %acceleration
    v_dot(l+1)= ((t_c(l)*cosd(alpha(l)))/m_c(l))- (g_h(l)*sind(gam(l)));
    %pitch rate
    gam_dot(l+1)= -((g_h(l)*cosd(gam(l)))/v(l))+ (t_c(l)*sind(alpha(l))/(m_c(l)*v(l)))+ ((v(l)*cosd(gam(l)))/(Re+r(l)));
    %drag
    %D(l) = 0.5*density(l)*v(l)^2*Aw*cd;
     
    %point mass equations
    v(l+1)=v(l)+(t_c(l)/m_c(l))-(g_h(l)*sind(gam(l)));
    gam(l+1) = gam(l) -((g_h(l)*cosd(gam(l)))/v(l))+((v(l)*cosd(gam(l)))/(Re+r(l)));


    %v(l+1)=v(l)+ (((t_c(l)*cosd(alpha(l))))/m_c(l))- (g_h(l)*sind(gam(l)));
    %gam(l+1) = gam(l) -((g_h(l)*cosd(gam(l)))/v(l))+ (t_c(l)*sind(alpha(l))/(m_c(l)*v(l)))+((v(l)*cosd(gam(l)))/(Re+r(l)));
    x(l+1) = x(l) + ((Re*v(l)*cosd(gam(l)))/(Re+r(l)));
    r(l+1) = r(l) + (v(l)*sind(gam(l)));
   
end
t1=0:l;
    %v = interp1(TIME,v,t);
    %Amb_pressure = interp1(TIME,PRESSURE,y);
    %Air_density = interp1(HEIGHT,DENSITY,y);
    %speedofS = interp1(HEIGHT,SPEEDofSOUND,y); 
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
subplot(3,2,2); plot(t1,r/1000);
namings('Time(s)','Height(km)','Height');
subplot(3,2,3); plot(x/1000,r/1000);
namings('Range(km)','Height(km)','Height vs Range');
subplot(3,2,4); plot(t1,v); 
namings('Time(s)','Velocity(m/s)','Velocity');
subplot(3,2,5); plot(t1,gam);
namings('Time(s)','Gamma(deg)','Gamma');
subplot(3,2,6); plot(t1,alpha);
namings('Time(s)','Alpha(deg)','Alpha');
figure;
subplot(3,2,1); plot(r/1000,temp);
namings('Height(km)','Temperature(k)','Temperature');
subplot(3,2,2); plot(r/1000,pressure);
namings('Height(km)','Pressure(kN/m^2)','Ambient Pressure');
subplot(3,2,3); plot(r/1000,SpeedofSound);
namings('Height(km)','Speed of Sound(m/s^2)','Speed of Sound');
subplot(3,2,4); plot(r/1000,density);
namings('Height(km)','Air Density(kg/m^3)','Air Density');
subplot(3,2,5); plot(r/1000,g_h);
namings('Height(km)','g(m/s^2)','Acceleration due to Gravity');

%converting column matrix to row matrix
v=v'; x=x'; r=r'; gam=gam';

%exporting data to excel sheet
q=table(v,x,r,gam);
filename3 = 'C:\Users\hp\Desktop\DRDO\outputsSphericalModel.xlsx';
location3='A1';
exportToExcel(filename3,location3,q);