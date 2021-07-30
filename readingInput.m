function [TIME,THR,MASS,theta1]=readingInput(filename,location)
    
    sat= xlsread(filename,location);
    TIME = sat(:,2); 
    THR = sat(:,3);
    MASS = sat(:,1);
    theta1= sat(:,4);

end