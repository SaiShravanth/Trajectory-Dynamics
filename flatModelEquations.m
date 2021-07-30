function [alpha,v_dot,gam_dot,v,gam,x,y]=flatModelEquations(l,t_c,m_c,theta,g_h)
    
    alpha(l+1) = theta(l) - gam(l);
    
    %acceleration+
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