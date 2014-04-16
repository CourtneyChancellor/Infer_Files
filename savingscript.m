i=1:25;
t=i*0.1;

load('saved0.mat')
rescomb{1}=saved;


for j=1:9
    fname=sprintf('saved%d.mat',t(j));
    load(fname);
    rescomb{j+1}=BB_BB;
    clear BB_BB
end

load('saved1.000000e+00.mat')
rescomb{11}=BB_BB;

for j=11:19
    fname=sprintf('saved%d.mat',t(j));
    load(fname);
    rescomb{j+1}=BB_BB;
    clear BB_BB
end

load('saved2.000000e+00.mat')
rescomb{21}=BB_BB;

for j=21:25
    fname=sprintf('saved%d.mat',t(j));
    load(fname);
    rescomb{j+1}=BB_BB;
    clear BB_BB
end

