function HH = enleve_alph(alph, FF)
dim = max(size(FF)) ;
nf = size(FF{1},2);
for ii = 1:nf
    if alph(ii) < 0
        alph(ii)    = - alph(ii);
        FF{1}(:,ii) = - FF{1}(:,ii);
    end
    for dd =1:dim
        HH{dd}(:,ii) =  alph(ii).^(1/dim) * FF{dd}(:,ii);
    end
end