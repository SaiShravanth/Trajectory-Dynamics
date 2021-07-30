function [temperature,Amb_pressure,Air_density,speedofS]=atmosphereModel(filename2,location2,y)
    
    %atmospheric model
    atm= xlsread(filename2,location2);

    HEIGHT = atm(:,1);
    TEMPERATURE = atm(:,2);
    PRESSURE = atm(:,3);
    DENSITY = atm(:,4);
    SPEEDofSOUND =atm(:,5);  %sqrt(1.405*287*Temp)
    
    %interpolation
    temperature = interp1(HEIGHT,TEMPERATURE,y);
    Amb_pressure = interp1(HEIGHT,PRESSURE,y);
    Air_density = interp1(HEIGHT,DENSITY,y);
    speedofS = interp1(HEIGHT,SPEEDofSOUND,y); 
    
end
