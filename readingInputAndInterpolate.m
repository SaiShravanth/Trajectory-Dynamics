function [t_c,m_c,theta]=readingInputAndInterpolate(filename,location,t)
    %reading input data
    sat= xlsread(filename,location);
    MASS = sat(:,1);
    TIME = sat(:,2); 
    THR = sat(:,3);
    MASS_FLOW = sat(:,5);
    theta1= sat(:,6);
    
    %interpolating
    t_c = interp1(TIME,THR,t);  
    m_c = interp1(TIME,MASS,t); 
    theta = interp1(TIME,theta1,t); 
end