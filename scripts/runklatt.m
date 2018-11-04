function runklatt(phoneme)

rawfn = 'wave.raw';

paramfn = ['docs-ja/',upper(phoneme),'.DOC'];

system(['./klatt ',paramfn]);

plotraw(rawfn)

playraw(rawfn)

end
