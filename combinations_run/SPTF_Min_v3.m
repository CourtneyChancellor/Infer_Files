function [alph, FF] = SPTF_Min_v3(AA_p, BB_p, Bord_p, N_NT_p,  max_iter, max_norm_err_p, GG) 
% [alph, FF] = SPTF_Min_v3(AA, BB, Bord, N_NT,  max_iter, max_norm_err, SolIni) 

clear global ntA ntAtA ntAtB AA BB Bord dim N_NT NN AA_AA AA_BB err_0 max_norm_err Ke Fe

global ntA ntAtA ntAtB;
global AA BB Bord dim;
global N_NT NN;
global AA_AA AA_BB;
global err_0 max_norm_err; 
global Ke Fe; 

Ke = zeros(max_iter, max_iter);
Fe = zeros(max_iter,1);

AA = AA_p;
BB = BB_p;
Bord = Bord_p;
N_NT = N_NT_p;
max_norm_err = max_norm_err_p;

dim = size(AA,1);
ntA = size(AA,2); 

ntB = size(BB{1},2); 

if ~exist('GG','var') || isempty(GG)
    disp(['pb sans fonctions initiales -> CL homogènes']);
else
    BB = ActualiseSM(ones(size(GG{1},2),1) , GG);
    ntB = size(BB{1},2);
end

for dd = 1:dim
    NN(dd)   = size(N_NT{dd},1);
    for kk = 1:ntA
        AA{dd,kk} (Bord{dd},: ) = 0;
        AA{dd,kk} (:,Bord{dd} ) = 0;
        AA{dd,kk} (Bord{dd},Bord{dd}) = eye(max(size(Bord{dd})));
    end
    BB{dd} (Bord{dd}, :) = 0;
end

err_0 = calc_norm(BB);

%============= valeurs calculés automatiquement =============
for kk = 1:ntA
    for ll = 1:ntA
        for dd = 1:dim
            AA_AA{dd,ntA*(ll-1)+kk} =  AA{dd,ll}' * AA{dd,kk} ;
        end
    end
end
for kk = 1:ntA
    for dd = 1:dim
        AA_BB{dd}(:,(ntB*(kk-1)+1):(ntB*(kk-1)+ntB) ) = AA{dd,kk}'*BB{dd};
    end
end

ntAtA = size(AA_AA, 2);
ntAtB = size(AA_BB{1},2); 

%============================================================
FF = cell(1,dim);
alph = [];

for iter = 1:max_iter
    disp(['===========================================']);
    disp(['On est à la ',num2str(iter) ,'eme iteration']);
    disp(['-------------------------------------------']);

    [R, norm_err] = FV_calc_RS(alph,FF);
    disp(['norm_err avant enrich ' , num2str(norm_err)])

    if norm_err < max_norm_err 
        break
    end

    for dd = 1:dim
        FF{dd} = [FF{dd} , R{dd}];
    end

    alph = FV_calc_alpha(FF);
    disp(['alph  ' , num2str(alph')])
    
    Sol.a = alph; Sol.F = FF; save Sol Sol;
end


%==========================================================================
%==========================================================================
function [CC, ntC] = ActualiseSM(alph, FF)
% calcul de B-A*(sum alph F)
global ntA ntB;
global AA BB dim;
nf = size(FF{1},2);
for ii = 1:nf
    if alph(ii) < 0
        alph(ii)    = - alph(ii);
        FF{1}(:,ii) = - FF{1}(:,ii);
    end
    for dd =1:dim
        x{dd}(:,ii) =  alph(ii).^(1/dim) * FF{dd}(:,ii);
    end
end
CC = BB; 
ntC = size(CC{1},2);                                      
for kk = 1:ntA  
    for ff = 1:nf
        ntC = ntC + 1; 
        CC{1}(:,ntC) = - AA{1,kk}*x{1}(:,ff);
        for d2=[2:dim]
             CC{d2}(:,ntC) = AA{d2,kk}*x{d2}(:,ff);
        end
    end
end
%==========================================================================
%==========================================================================
function res = FV_calc_alpha(FF)
global dim ntAtA ntAtB;
global AA_BB AA_AA;
global Ke Fe; 

nf = size(FF{1},2); 

for jj = 1:nf
    for kk = 1:ntAtA
        prod_aux = 1;
        for dd = 1:dim
            prod_aux = prod_aux * ...
                (FF{dd}(:,nf)' * AA_AA{dd,kk} * FF{dd}(:,jj));
        end
        Ke(nf,jj) = Ke(nf,jj) + prod_aux;
    end
end

%attention 
% ca marche car AtA est symetrique !!

for ii = 1:nf-1;
    Ke(ii,nf) = Ke(nf,ii);
end

prod_aux_2 = ones(1,ntAtB) ;
for dd=[1:dim]
    prod_aux_2 = prod_aux_2 .* (FF{dd}(:,nf)' * AA_BB{dd});
end
Fe(nf) =  sum(prod_aux_2) ;

res = Ke(1:nf, 1:nf)\Fe(1:nf);
%==========================================================================
%==========================================================================
function [R, norm_err] = FV_calc_RS(alph, FF)
global Bord err_0 max_norm_err;
global N_NT NN ;
global dim ntA ntAtA AA AA_AA;
for dd = 1:dim
    R{dd} = ones(NN(dd),1) ; 
    R{dd}(Bord{dd}) = 0;
    R{dd} = R{dd}/sqrt(R{dd}'*N_NT{dd}*R{dd});
end

max_err_RS = 1 ;
comp_nR = 0;
[CC, ntC] = ActualiseSM(alph, FF);
norm_err = calc_norm(CC)/err_0; 
if norm_err < max_norm_err
    return
end
for kk = 1:ntA
    for dd = 1:dim
        AA_CC{dd}(:,(ntC*(kk-1)+1):(ntC*(kk-1)+ntC) ) = AA{dd,kk}'*CC{dd};
    end
end

while max_err_RS > 1e-8   % c'est la racine carrée de la précision machine   
    comp_nR = comp_nR + 1 ;    
    R_old = R;
    for dd = 1:dim
        R{dd} = KRMF(AA_CC, R, dd); % pour le moment non //able car on ne 
                                            %peut pas mettre R_old
    end
    
    max_err_RS = calc_diff_R(R, R_old);
    if comp_nR/15 == round (comp_nR/15)
        disp(['-- comp it --- ', num2str(comp_nR) , ' - err - ' , ...
            num2str(max_err_RS)]);
    end
    if comp_nR > 200
        disp('Arret des iterations pour le calcul de R, S .............');
        break
    end
end
% ================== on normalise le résultat selon || . || At A
for dd = 1:dim
    R{dd} = R{dd}/sqrt(R{dd}'*N_NT{dd}*R{dd})  ;
end
norm_aux = 0;
for kk = 1:ntAtA
     prod_aux = 1;
    for d2=[1:dim]
        prod_aux = prod_aux * (R{d2}'* AA_AA{d2,kk} * R{d2});  
    end
    norm_aux = norm_aux + prod_aux;
end
norm_aux = sqrt(norm_aux);
for dd = 1:dim
    R{dd} = R{dd} / norm_aux^(1/dim)  ;
end
%==========================================================================
%==========================================================================
function res = KRMF(AA_CC , R, d1)
global dim ntAtA ;
global NN;
global AA_AA AA;
ntC_ntA = size(AA_CC{1},2);
N_d1 = NN(d1);
Mat_K  = sparse(N_d1 , N_d1);
for kk = 1:ntAtA
    prod_aux = 1;
    for d2=[1:d1-1,d1+1:dim]
        prod_aux = prod_aux * (R{d2}'* AA_AA{d2,kk} * R{d2});  
    end
    Mat_K = Mat_K + AA_AA{d1,kk} * prod_aux;
end
% ======================== terme source ================================
prod_aux_3 = ones(1,ntC_ntA) ;
for d2=[1:d1-1,d1+1:dim]
    prod_aux_3 = prod_aux_3 .* (R{d2}' * AA_CC{d2});
end
Vec_F  = AA_CC{d1} * prod_aux_3' ;
% ======================================================================
res = Mat_K \ Vec_F  ;
%==========================================================================
%==========================================================================
function res_err = calc_diff_R(G_G , G_G_p)
global N_NT dim ;
alph   = [1 ; -1];
for dd = 1:dim 
    FF{dd}  = [G_G{dd}, G_G_p{dd}];
end
prod_aux = ones(2,2);
for dd = 1:dim
    prod_aux = prod_aux .* (FF{dd}' *  N_NT{dd} * FF{dd});
end
res_err = sqrt(abs(alph' * prod_aux * alph)) ;
%==========================================================================
%==========================================================================
function err = calc_norm(CC)
% calcule la norme ||C||
% C = B-Ax
global dim 
ntC  = size(CC{1},2);
prod_aux = ones(ntC, ntC);
for dd = 1:dim
    prod_aux = prod_aux .* (CC{dd}'* CC{dd});
end
err = sqrt(abs( sum(sum(prod_aux)) ));
