g.I = gpuArray(imread('./data/cat.1.jpg'));
g.I_med = medfilt2(g.I);



m.I = gather(g.I);