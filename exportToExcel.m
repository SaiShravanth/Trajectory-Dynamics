function excel=exportToExcel(filename3,location3,tablename) 
    writetable(tablename,filename3,'Sheet',1,'Range',location3);
end