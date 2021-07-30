%%
clc; close all; 

filename1='C:\Users\hp\Desktop\DRDO\data.xlsx';
location1= 'A1:F600';
%%
%Input Data Model
k=0.05;
[TIME,THR,MASS,theta1]=readingInput(filename1,location1);

%%
%initial conditions 
[v,x,r,gam,alpha,v_dot,gam_dot] = ic();
mach_no = 0;
Re = 6378137;

%%
% AeroData
%=========
aerodata_s1 = [...
    0.0  	0.21
    0.4     0.22
    0.8     0.23
    0.9     0.28
    1.0     0.30
    1.1     0.29
    1.2     0.28
    1.5     0.27
    2.0     0.26
    3.0     0.255
    4.0     0.24
    5.0     0.23
    6.0     0.22
    10.0    0.22];

mach_s1 = aerodata_s1(:,1);
aero_s1_cd = aerodata_s1(:,2);

%%
%Initialisations
conv_deg2rad = pi/180.0;
R0 = 6378137.0;
GM = 3.986005E14;
G0 = GM/R0^2;
dia = 1.0;
area = pi*dia^2/4;
exitdia_s1 = 0.600;

%%
% Vehicle Data

mass_struct_s1 = 150.0;
mass_prop_s1 = 1000.0;
mass_payload = 50.0;

mass_launch = mass_struct_s1 + mass_prop_s1 + mass_payload;
mass_pl = mass_payload;

mass = mass_launch;

t_burn = 40;

thrust= 0;
g_h=9.81;

%% 
for l=1:length(THR)-1
    
    %exit condition
    if(r(l)<=0)
        break;
    end
    
    theta = intpol(TIME,theta1,l)*conv_deg2rad;
    alpha = theta - gam(l);
    
    if(l<=40)
        dc = intpol(mach_s1,aero_s1_cd,mach_no);
    else
        dc = 0.1;
    end
   
    [density,vel_sound,temp,amb_press] = atmos_model(r(l));
    
    t_c=intpol(TIME,THR,l);
    thrust = t_c- amb_press*pi*0.6*0.6/4;
    if(thrust<0)
        thrust=0;
    end
    m_c= intpol(TIME,MASS,l);
    
    dyp = 0.5 * density* v()*v(l) * area;
    drag = dyp * dc;
    
    %acceleration
    v_dot= ((thrust*cosd(alpha)-drag)/m_c);
    %pitch rate
    gam_dot= -((g_h*cosd(gam(l)))/v(l))+ (thrust*sind(alpha)/(m_c*v(l)))+ ((v(l)*cosd(gam(l)))/(Re+r(l)));
   
    v(l+1)=v(l)+ ((((thrust*cosd(alpha)-drag))/m_c)- (g_h*sind(gam(l))))*k;
    
    if l <= 5
        gam(l+1) = gam(l);
    else
         gam(l+1) = (gam(l)+ k*(-((g_h*cosd(gam(l)))/v(l))+ (thrust*sind(alpha)/(m_c*v(l)))+((v(l)*cosd(gam(l)))/(Re+r))))*(pi/180);
    end   
   
    x(l+1) = x(l) + (v(l)*cosd(gam(l)))*k;
    r(l+1) = r(l) + (v(l)*sind(gam(l)))*k;
    
    %gravity model
    [g_h] = gc(r(l));

    mach_no = v/vel_sound;
   
end

t1=0:l;
%%
figure;

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
subplot(3,2,6); plot(t,alpha);
namings('Time(s)','Alpha(deg)','Alpha');

%converting column matrix to row matrix
v=v'; x=x'; r=r'; gam=gam';
%%
%exporting data to excel sheet
q=table(v,x,r,gam);
filename3 = 'C:\Users\hp\Desktop\DRDO\outputsSphericalModel.xlsx';
location3='A1';
exportToExcel(filename3,location3,q);