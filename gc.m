function [gh,gravity]= gc(r,gam,k,gravity)
    R0 = 6378137.0;
    GM = 3.986005E14;
    G0 = GM/R0^2;
    gh = G0 * (R0/(R0+r))^2;
    g_dot = gh*sin(gam)*k;
    gravity = gravity + g_dot;
end
