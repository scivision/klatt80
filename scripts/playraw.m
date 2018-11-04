function playraw(fn)

fs = 10000;

dat = loadraw(fn);
dat = repmat(dat,[3,1]);

p = audioplayer(dat, fs);

playblocking(p)

end
