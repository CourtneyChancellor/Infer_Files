%%%% Consistency with PH file Must be Respected %%%%
for iter = 1:50
    
    load('ERBB_AA_results.mat')
    change=[1,16,8,17,2,3,4,6,18,19,5,7,10,11,13,9,15,12,14,20];
    AA=AA(change,:);
    err_norm = 1e-2;
        
    
nreactions=size(AA,2);



%%% Combine relevant dimensions
for i=1:nreactions
 AA{13,i}=kron(AA{13,i},kron(AA{14,i},kron(AA{15,i},kron(AA{16,i},AA{17,i}))));
    AA{8,i}=kron(AA{8,i},kron(AA{9,i},kron(AA{10,i},AA{11,i})));
    AA{1,i}=kron(AA{1,i},kron(AA{2,i},kron(AA{3,i},AA{4,i})));
end
initial{13}=kron(initial{13},kron(initial{14},kron(initial{15},kron(initial{16},initial{17}))));
initial{8}=kron(initial{8},kron(initial{9},kron(initial{10},initial{11})));
initial{1}=kron(initial{1},kron(initial{2},kron(initial{3},initial{4})));
AA([2,3,4,9,10,11,14,15,16,17],:)=[];
initial([2,3,4,9,10,11,14,15,16,17])=[];
%%%%%%%%



dim  = size(AA,1)  ;
NN = zeros(1,dim);
species=size(Sorts,1);

for i=1:dim
    ID{i}=eye(size(AA{i,1},1));
    AA{i,nreactions+1}=ID{i};
    NN(i)=size(ID{i},1);
    N_NT{i}=ID{i};
    Bord{i}=[];
    FF{i}=[];
    CrdX{i} =[0:size(AA{i,1},1)-1]';
end



pdt = .1;

 for jj = 1:size(AA,2);
        for dd = 1:1
            AA{dd, jj} = - pdt * AA{dd, jj}; % please check the sign % equation Id dphi/dt + AA  phi = 0  ?
        end
 end
 
 for jj = size(AA,2)+1;
        for dd = 1:dim
            AA{dd, jj} = N_NT{dd};
        end
 end
 
 
 
 if exist('BB.mat', 'file') == 2
        load BB;
        load time;
        load count;
    else
        time = 0;
        count=1;
        
for i=1:dim
    BB{i}=initial{i};
end


temp=BB{dim};
for i=dim-1:-1:1
        temp= kron(BB{i}, temp);
end
saved{1}=temp;
        save savedfile_co8 saved
  end
   
   

    [alph, FF] = SPTF_Min_v3(AA, BB, Bord, N_NT,  5, err_norm) ;
    
    
    time = time + pdt;
    save time time
    clear BB
    
    BB = enleve_alph(alph,FF);
    
    save BB BB
    
%     if mod(time+1e-4,5) < 1e-2
%         save (['BB_', num2str(time),'.mat'], 'BB')
%     end
    
    BB_BB      = zeros(prod(NN(1:dim-1)),length(rvar));
    for ib = 1:size(BB{1},2)
        temp=BB{dim}(:,ib);
        for i=dim-1:-1:1
            temp= kron(BB{i}(:,ib), temp);
        end
        BB_BB = BB_BB + temp;
    end

    if mod(time, 1)==0
        count=count+1;
    load('savedfile_co8.mat')
    saved{count}=BB_BB;
    save savedfile_co8 saved
    end
    
    
    close all
    clear all;
end


%%%%%%%
% 
% figure
% 
% tsize=size(simulationph,1);
% 
% x=1:size(states,1);
% for i=1:tsize-2
%     plot(x,simulationph(i,:),x,summed{6}(:,i),'o')
%     legend('Simulation','PGD')
%     pause
% end
