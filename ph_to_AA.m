function [AA,Sorts,initial,tfinal] = ph_to_AA(ph_filename)



%% Execute Pretreatment and Load Data File

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% testing.sh removes cooperative syntax, replaces with individual sorts
%process_command=strcat('./testing.sh',32,ph_filename);
%[f,~]=system(process_command);

%% get reactions
myfile=fopen('FOO/importfile.txt','r');
Reactions = textscan(myfile, repmat('%s',1,500), 'delimiter',' ', 'CollectOutput',true);
Reactions=Reactions{1};
fclose(myfile);

%% get sorts with their size
myfile2=fopen('FOO/sorts_size.txt','r');
Sorts = textscan(myfile2, repmat('%s',1,500), 'delimiter',' ', 'CollectOutput',true);
Sorts= Sorts{1};
fclose(myfile2);


%% get intial conditon and final time

myfile3=fopen('FOO/initial_final.txt','r');
Initial = textscan(myfile3, repmat('%s',1,500), 'delimiter',' ', 'CollectOutput',true);
Initial= Initial{1};
fclose(myfile3);

tfinal=str2num(Initial{1,1});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
no_reactions=size(Reactions,1);
no_species=size(Sorts,1);

for i=1:no_species

%%% Create empty matrices/vectors for later use

    ID_mats{i}=eye(str2num(Sorts{i,2})+1);
    zero_mats{i}=zeros(str2num(Sorts{i,2})+1);
    zero_vecs{i}=zeros(str2num(Sorts{i,2})+1,1);
    
%%% Replace names in Reactions with species number

    s=find(strcmp(Sorts(i,1),Reactions)==1);
    Reactions(s)={i};
    
    s2=find(strcmp(Sorts(i,1),Initial)==1);
    Initial(s2)={i};
    
end


%% Convert all input to numerical value

Reactions(find(strcmp('->',Reactions)==1))={[]};
Reactions(find(strcmp('@',Reactions)==1))={[]};
Reactions(find(strcmp('~',Reactions)==1))={[]};


ConvertedReactions=NaN(size(Reactions));
for i=1:size(Reactions,1)
    for j=1:size(Reactions,2)
        element=Reactions(i,j);
        element=element{1};
        if ischar(element)== 1
            element=str2num(element);
        end
        if isempty(element)==1
            element=NaN;
        end
        ConvertedReactions(i,j)=element;
    end
end

%%% convert initial condition to feasible vector
initial_cond=zeros(no_species,1);
for i=1:2:no_species*2
    initial_cond((i+1)/2)=str2num(Initial{2,i+1})+1;
end

initial=cell(no_species,1);
for i=1:no_species
    tmpvec=zero_vecs{i};
    tmpvec(initial_cond(i))=1;
    initial{i}=tmpvec;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Create AA using Converted Reactions

AA=cell(no_species,no_reactions*2);

for i=1:2:no_reactions*2

    reaction=ConvertedReactions((i+1)/2,:);
    
   %%% conditions NaN target NaN rate NaN stochastic_a
    j=1;
    while isnan(reaction(j))==0
    	    tmp_vec=zero_vecs{reaction(j)};
    	    tmp_vec(reaction(j+1)+1)=1;
            AA{reaction(j),i}=diag(tmp_vec); %fill from
            AA{reaction(j),i+1}=diag(tmp_vec); %fill to
            j=j+2;
    end
    
    j=j+1; %skip first NaN
    
    %go from this state
    tmp_vec=zero_vecs{reaction(j)};
    tmp_vec(reaction(j+1)+1)=1;
    AA{reaction(j),i}=diag(tmp_vec);
    
    % to this state
    tmp_mat=zero_mats{reaction(j)};
    tmp_mat(reaction(j+2)+1,reaction(j+1)+1)=1;
    AA{reaction(j),i+1}=tmp_mat;

    j=j+4; %skip sectond NaN

    Rates{i}= reaction(j);
    Stoch_Abs{i}= reaction(j+2);
    
    %%% fill empty (nonreacting) species
    for k=1:no_species
        if isempty(AA{k,i})
            AA{k,i}=ID_mats{k};
            AA{k,i+1}=ID_mats{k};
        end
    end
    

    %% associate negative and rate element with 1st species
    AA{1,i}= -1*Rates{i}*AA{1,i};
    AA{1,i+1}= Rates{i}*AA{1,i+1};

    
end


    



end % end of function
