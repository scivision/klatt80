function dat = loadraw(fn)

fid = fopen(fn, 'r');

dat = fread(fid,'int16=>int16');

fclose(fid);

end