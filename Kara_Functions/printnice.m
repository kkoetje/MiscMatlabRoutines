% function printnice(Figname,Savename)
% Print a plot in a nice way
% First save as an eps (extension added in function), then convert to pdf
% Send the name of the plot, and what you'd like to call it

function printnice(Figname,Savename)
Savename=[Savename,'.eps'];
print(Figname,'-depsc','-r600',Savename);
eps = fileread(Savename);
fd = fopen(Savename, 'wt');
fwrite(fd, eps);
fclose(fd);
system(['epstopdf ' Savename]);
end