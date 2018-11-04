function plotraw(fn)

dat = loadraw(fn);

fs = 10000;

t = 0:1/fs:length(dat)*1/fs-1/fs;

plot(t,dat)
title(fn)
xlabel('time [sec]')
ylabel('amplitude')


end