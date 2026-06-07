% A novel marine predator whale optimization algorithm for global numerical optimization
% % Su Ya and Liu Yi  
function [Leader_score,Leader_pos,Convergence_curve,Total_time]=MPWOA(fhd,SearchAgents_no,Max_iter,lb,ub,dim,fun_num)

disp('MPWOA is now tackling your problem')
tic
Leader=CreateLeaderWhale(dim);                   % initialize position vector and score for the leader
PredatorWhales=CreateEmptyWhales(SearchAgents_no); 
PredatorWhales=Initialization(PredatorWhales,SearchAgents_no,dim,ub,lb); %Initialize the positions of search agents
stepsize=zeros(SearchAgents_no,dim);
Xmin=repmat(ones(1,dim).*lb,SearchAgents_no,1);
Xmax=repmat(ones(1,dim).*ub,SearchAgents_no,1);
Convergence_curve=zeros(1,Max_iter);
FADs=0.2;
PP=0.5;
R=rand();
while R==0.25||R==0.5||R==0.75
      R=rand;
end
PerIter=3;
CRR=zeros(1,SearchAgents_no);
t=1;% Loop counter
while t<Max_iter+1    % Main loop  

        CF=(1-t/Max_iter)^(2*t/Max_iter);    
     for i=1:SearchAgents_no        
        % Return back the search agents that go beyond the boundaries of the search space  
        PredatorWhales(i).Position=max(lb,min(ub,PredatorWhales(i).Position));
        PredatorWhales(i).Fitness=feval(fhd,PredatorWhales(i).Position',fun_num);
        PredatorWhales(i)=UpdatePersonalLocation(PredatorWhales(i)); 
        Leader=UpdateGlobalLocation(PredatorWhales(i).Best,Leader);  
     end  
    % *****************Memary save operator*******************************
     if t==1
        PredatorWhales_old=PredatorWhales;
     end       
        [PredatorWhales_old,PredatorWhales,CRR]=MemorySaveing1(PredatorWhales_old,PredatorWhales,SearchAgents_no,dim,CRR);      
        [PredatorWhales,CRR,Leader]=RankingStrategy(fhd,PredatorWhales,SearchAgents_no,dim,CRR,Leader,PerIter,PP,CF,lb,ub,fun_num);       
        RL=0.05*levy(SearchAgents_no,dim,1.5);   % Levy random number vector
        RB=randn(SearchAgents_no,dim);           % Brownian random number vector   
        a=3-t*((3)/Max_iter);      %   a=3-t*((3)/Max_iter)
        a2=-1+t*((-1)/Max_iter);   % a2 linearly dicreases from -1 to -2 
    % Update the Position of search agents 
    for i=1:SearchAgents_no       
        R=4*R*(1-R);  
        r1=rand();    % r1 is a random number in [0,1]
        r2=rand();    % r2 is a random number in [0,1]   
        A=a*sin((2*pi)*r1);
        C=2*r2;            
        b=1;               
        l=(a2-1)*rand+1;          
        p=rand();             
        for j=1:dim        
             if abs(A)>=2            
                stepsize(i,j)=RB(i,j)*(Leader.Position(j)-CF*PredatorWhales(i).Best.Position(j)-RB(i,j)*PredatorWhales(i).Position(j)); 
                PredatorWhales(i).Position(j)=PredatorWhales(i).Position(j)+PP*R*stepsize(i,j);   
             elseif abs(A)>1 && abs(A)<2 
                stepsize(i,j)=RL(i,j)*(Leader.Position(j)-CF*PredatorWhales(i).Best.Position(j)-RL(i,j)*PredatorWhales(i).Position(j)); 
                PredatorWhales(i).Position(j)=PredatorWhales(i).Position(j)+PP*R*stepsize(i,j);  
             elseif abs(A)<=1  
                  if p<0.5                  
                     D_Leader=abs(C*Leader.Position(j)-PredatorWhales(i).Position(j));       
                     PredatorWhales(i).Position(j)=(1-CF)*Leader.Position(j)-A*D_Leader;                          
                  elseif p>=0.5 
                     distance2Leader=abs(Leader.Position(j)-PredatorWhales(i).Position(j));   
                     PredatorWhales(i).Position(j)=distance2Leader*exp(b.*l).*cos(l.*2*pi)+(1-CF)*Leader.Position(j); 
                  end
             end         
       end
    end
% **************************************************************************************************************************    
  for i=1:SearchAgents_no   
      % Return back the search agents that go beyond the boundaries of the search space
      PredatorWhales(i).Position=max(lb,min(ub,PredatorWhales(i).Position));    
      PredatorWhales(i).Fitness=feval(fhd,PredatorWhales(i).Position',fun_num);
      % Update the leader
      Leader=UpdateGlobalLocation(PredatorWhales(i),Leader);         
   end  
  % ***************** Memary save operator *******************************  
   [PredatorWhales_old,PredatorWhales]=MemorySaveing2(PredatorWhales_old,PredatorWhales,SearchAgents_no,dim);
   %********** Eddy formation and FADs? effect ***********
   PredatorWhales=FADsEffect(SearchAgents_no,dim,Xmin,Xmax,FADs,CF,PredatorWhales_old,PredatorWhales);
   [Leader_score,Leader_pos]=GetResults(Leader);
   Convergence_curve(t)=Leader_score;    
   display(['Iteration:',num2str(t), '   Leader_score:',num2str(Leader_score)]);       
   t=t+1;
end
Total_time=toc;



