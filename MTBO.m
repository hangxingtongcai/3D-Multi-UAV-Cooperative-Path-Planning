


function [Destination_position,Destination_fitness,Convergence_curve]=MTBO(N,Max_iteration,lb,ub,dim,fobj)

% disp('MTBO: Mountaineering Team Based Optimization')

CostFunction = @(x) fobj(x);

nVar = dim;          % Number of Variables
VarSize = [1 nVar]; 
VarMin = lb;       %Variables Lower Bound
VarMax =ub ;       %Variables Upper Bound

%% MTBO Parameters

MaxIt = Max_iteration;        % Maximum Number of Iterations

nPop = N;           % Population Size

%% Initialization 

% Empty Structure for Individuals
empty_individual.Position = [];
empty_individual.Cost = [];

% Initialize Population Array
pop = repmat(empty_individual, nPop, 1);

% Initialize Best Solution
BestSol.Cost = inf;

% Initialize Population Members
for i=1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
    
    if pop(i).Cost < BestSol.Cost
        BestSol = pop(i);
    end
end

% Initialize Best Cost Record
BestCosts = zeros(MaxIt,1);

%% MTBO Main Loop

for it=1:MaxIt
    
    % Calculate Population Mean
    Mean = 0;
    for i=1:nPop
        Mean = Mean + pop(i).Position;
    end
    Mean = Mean/nPop;
    
    % Select Leader
    Leader = pop(1);
 
    for i=2:nPop
        if pop(i).Cost < Leader.Cost
            Leader = pop(i);
               end
    end
    
     
    for i=1:nPop
        % Create Empty Solution
        newsol = empty_individual;
      
     
        ii=i+1;
        if ii>nPop
            ii=1;
        end
       Li=(0.25+0.25*rand);
        Ai=(0.75+0.25*rand);
        Mi=(0.75+0.25*rand);
        if rand<Li
        newsol.Position = pop(i).Position ...
            +rand(VarSize).*(pop(ii).Position-pop(i).Position) + rand(VarSize).*(Leader.Position-pop(ii).Position);
        elseif rand<Ai
              newsol.Position = pop(i).Position ...
            + 1*rand(VarSize).*(pop(i).Position-pop(nPop).Position); 
         elseif rand<Mi
              newsol.Position = pop(i).Position ...
            + 1*rand(VarSize).*(Mean-pop(i).Position); 
        else

            newsol.Position = unifrnd(VarMin, VarMax, VarSize); 

        
    end
        
   
        newsol.Position = max(newsol.Position, VarMin);
        newsol.Position = min(newsol.Position, VarMax);

        newsol.Cost = CostFunction(newsol.Position);
   
        if newsol.Cost<pop(i).Cost
            pop(i) = newsol;
             if pop(i).Cost < Leader.Cost
            Leader = pop(i);
                      end
        end
    end
% Sort Population
    [uuu, SortOrder]=sort([pop.Cost]);
    pop = pop(SortOrder);
   
    % Store Record for Current Iteration
 Convergence_curve(it) =pop(1).Cost;
    
    % Show Iteration Information
    % disp(['Iteration ' num2str(it) ': Best Cost = ' num2str( Convergence_curve(it))]);
    
end

%% Results
Destination_fitness=pop(1).Cost;
Destination_position=pop(1).Position;
end
