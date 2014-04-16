function FF = concatene(G_G , G_G_p)
dim = max(size(G_G)) ;
for dd = 1:dim 
    FF{dd}  = [G_G{dd}, G_G_p{dd}];
end