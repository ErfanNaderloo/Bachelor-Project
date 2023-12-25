clc;
clear;
close all;

%% Problem Definition
global NFE;
NFE=0;

model = model;

Nd=model.Nd;         % subset of potential Depots
Nc=model.Nc;         % subset of customers (clients)
V=model.V;           % set of all available primary vehicles at first echelon

% model.pAmount = 100;

CostFunction=@(cr) costFunction(cr,model);     % Cost Function

nVar = Nc +  Nd - 1 + V +  Nd + V -1 ;  

VarSize=[1 nVar];   % Size of Decision Variables Matrix

VarMin=0;          % Lower Bound of Variables
VarMax=1;          % Upper Bound of Variables

% Number of Objective Functions
nObj=2;


%% NSGA-II Parameters

MaxIt=100;      % Maximum Number of Iterations

nPop=50;        % Population Size

pCrossover=0.7;                         % Crossover Percentage
nCrossover=2*round(pCrossover*nPop/2);  % Number of Parnets (Offsprings)

beta = 0.1*(VarMax-VarMin);  % Crossover Step Size

pMutation=0.3;                          % Mutation Percentage
nMutation=round(pMutation*nPop);        % Number of Mutants

mu=0.1;                    % Mutation Rate

sigma=0.2*(VarMax-VarMin);  % Mutation Step Size


%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.Rank=[];
empty_individual.DominationSet=[];
empty_individual.DominatedCount=[];
empty_individual.CrowdingDistance=[];
empty_individual.DominatedCount=[];
empty_individual.Sol=[];

pop=repmat(empty_individual,nPop,1);

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    [pop(i).Cost , pop(i).Sol]=CostFunction(pop(i).Position);
    
end

% Non-Dominated Sorting
[pop ,F]=NonDominatedSorting(pop);

% Calculate Crowding Distance
pop=CalcCrowdingDistance(pop,F);

% Sort Population
[pop, F]=SortPopulation(pop);

nfe = zeros(1,nPop);

%% NSGA-II Main Loop
for it=1:MaxIt
    
    % Crossover
    popc=repmat(empty_individual,nCrossover/2,2);
    for k=1:nCrossover/2
        
        i1=randi([1 nPop]);
        p1=pop(i1);
        
        i2=randi([1 nPop]);
        p2=pop(i2);
        
        [popc(k,1).Position ,popc(k,2).Position]=Crossover(p1.Position,p2.Position,beta);
        
        [popc(k,1).Cost,popc(k,1).Sol]=CostFunction(popc(k,1).Position);
        [popc(k,2).Cost,popc(k,2).Sol]=CostFunction(popc(k,2).Position);
        
    end
    popc=popc(:);
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);
    for k=1:nMutation
        
        i=randi([1 nPop]);
        p=pop(i);
        
        popm(k).Position=Mutate(p.Position,mu,sigma);
        
        [popm(k).Cost ,popm(k).Sol]=CostFunction(popm(k).Position);
        
    end
    
    % Merge
    popPool=[pop
         popc
         popm];
     
    % Non-Dominated Sorting
    [popPool ,F]=NonDominatedSorting(popPool);

    % Calculate Crowding Distance
    popPool=CalcCrowdingDistance(popPool,F);

    % Sort Population
    [popPool ,~]=SortPopulation(popPool);
    
    % Truncate
    pop=popPool(1:nPop);
    
    % Non-Dominated Sorting
    [pop ,F]=NonDominatedSorting(pop);

    % Calculate Crowding Distance
    pop=CalcCrowdingDistance(pop,F);

    % Sort Population
    [pop ,F]=SortPopulation(pop);
    
    % Store F1
    F1=pop(F{1});
      nfe(it)=NFE;
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);
    
    % Plot F1 Costs

    
end

%% Results

COSTS=[F1.Cost];
COSTS(2,:)=COSTS(2,:);
plot(COSTS(1,:),COSTS(2,:),'ro','MarkerFaceColor',[1 0 0]);
xlabel('F1');
ylabel('F2');

grid on;

disp('*************************');
disp('*************************');
disp('*************************');
disp('Parto Obj Func = ');
disp(COSTS);





