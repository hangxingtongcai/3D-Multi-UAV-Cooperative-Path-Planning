% % % Manta ray foraging optimization (MRFO) code v1.0.
% % function [BestValueo,Bestfitnso,XTargeto]=SAMRFO(nPop,MaxIt,fobj,Low,Up,Dim,RunNo)
% % BestValue=zeros(RunNo,Dim);
% % XTarget=zeros(RunNo,MaxIt);
% % BestCost=zeros(RunNo,1);
% % ix=0;
% % while ix<=RunNo
% % %Tm(1): temperature
% % %Tm(2): cooling rate
% % %Tm(3): % minimum temperature
% % %Tm=[10, 0.95,0.1];
% % Tm=[max(Up),0.95,0.01];
% % [PopFit,BestF,PopPos,BestX] = simulatedAnnealing(fobj,nPop,Dim,Up,Low,Tm);
% % HisBestFit=zeros(MaxIt,1);
% % for It=1:MaxIt  
% %      Coef=It/MaxIt; 
% % 
% %        if rand<0.5
% %           r1=rand;                         
% %           Beta=2*exp(r1*((MaxIt-It+1)/MaxIt))*(sin(2*pi*r1));    
% %           if  Coef>rand                                                      
% %               newPopPos(1,:)=BestX+rand(1,Dim).*(BestX-PopPos(1,:))+Beta*(BestX-PopPos(1,:)); %Equation (4)
% %           else
% %               IndivRand=rand(1,Dim).*(Up-Low)+Low;                                
% %               newPopPos(1,:)=IndivRand+rand(1,Dim).*(IndivRand-PopPos(1,:))+Beta*(IndivRand-PopPos(1,:)); %Equation (7)         
% %           end              
% %        else 
% %             Alpha=2*rand(1,Dim).*(-log(rand(1,Dim))).^0.5;           
% %             newPopPos(1,:)=PopPos(1,:)+rand(1,Dim).*(BestX-PopPos(1,:))+Alpha.*(BestX-PopPos(1,:)); %Equation (1)
% %        end
% % 
% %     for i=2:nPop
% %         if rand<0.5
% %            r1=rand;                         
% %            Beta=2*exp(r1*((MaxIt-It+1)/MaxIt))*(sin(2*pi*r1));    
% %              if  Coef>rand                                                      
% %                  newPopPos(i,:)=BestX+rand(1,Dim).*(PopPos(i-1,:)-PopPos(i,:))+Beta*(BestX-PopPos(i,:)); %Equation (4)
% %              else
% %                  IndivRand=rand(1,Dim).*(Up-Low)+Low;                                
% %                  newPopPos(i,:)=IndivRand+rand(1,Dim).*(PopPos(i-1,:)-PopPos(i,:))+Beta*(IndivRand-PopPos(i,:));  %Equation (7)       
% %              end              
% %         else
% %             Alpha=2*rand(1,Dim).*(-log(rand(1,Dim))).^0.5;           
% %             newPopPos(i,:)=PopPos(i,:)+rand(1,Dim).*(PopPos(i-1,:)-PopPos(i,:))+Alpha.*(BestX-PopPos(i,:)); %Equation (1)
% %        end         
% %     end
% % 
% %            for i=1:nPop        
% %                newPopPos(i,:)=SpaceBound(newPopPos(i,:),Up,Low);
% %                newPopFit(i)=fobj(newPopPos(i,:));    
% %               if newPopFit(i)<PopFit(i)
% %                  PopFit(i)=newPopFit(i);
% %                  PopPos(i,:)=newPopPos(i,:);
% %               end
% %            end
% % 
% %             S=2;
% %         for i=1:nPop           
% %             newPopPos(i,:)=PopPos(i,:)+S*(rand*BestX-rand*PopPos(i,:)); %Equation (8)
% %         end
% % 
% %      for i=1:nPop        
% %          newPopPos(i,:)=SpaceBound(newPopPos(i,:),Up,Low);
% %          newPopFit(i)=fobj(newPopPos(i,:));    
% %          if newPopFit(i)<PopFit(i)
% %             PopFit(i)=newPopFit(i);
% %             PopPos(i,:)=newPopPos(i,:);
% %          end
% %      end
% % 
% %      for i=1:nPop
% %         if PopFit(i)<BestF
% %            BestF=PopFit(i);
% %            BestX=PopPos(i,:);            
% %         end
% %      end
% % 
% %        HisBestFit(It)=BestF;
% %       %disp(num2str([t BestSol.cost]))
% %      if mod(It,10)==0
% %        display(['At iteration ', num2str(It), ' the best fitness is ', num2str(HisBestFit(It))]);
% %     end
% % 
% % end
% % ix=ix+1;
% % BestCost(ix)=BestF;
% % BestValue(ix,:)=BestX;
% % XTarget(ix,:)= HisBestFit;
% % 
% % end
% % XTargeto=mean(XTarget);
% % Bestfitnso=mean(BestCost);
% % BestValueo=mean(BestValue);
% % end
% % 
% % function  X=SpaceBound(X,Up,Low)
% %     Dim=length(X);
% %     S=(X>Up)+(X<Low);    
% %     X=(rand(1,Dim).*(Up-Low)+Low).*S+X.*(~S);
% % 
% % end
% % 
% % 
% % function [fitness,BestF,wbest,BestX] = simulatedAnnealing(Fun,N,dim,ub,lb,Tm)
% % % Simulated annealing algorithm
% % Positions=initialization(N,dim,ub,lb);
% % BestF=inf;BestX=[];
% % temperature = Tm(1);      % initial temperature
% % iter = N;           %Number of iterations of the inner Monte Carlo loop
% % enegy=0;
% % value=Disturb(dim,lb,ub);
% % count = 1;
% % enegy(count)=Fun(value);
% % 
% % while temperature > Tm(3)      %stop iteration temperature
% %     for n = 1:iter
% %         enegy1 = Fun(value);
% %    temp_value = Disturb(dim,lb,ub);
% %         enegy2 = Fun(temp_value);
% % 
% %         delta_e = enegy2 - enegy1;
% % 
% %         if delta_e < 0
% %             value = temp_value;
% %         else
% %          P=exp(-delta_e/temperature);
% %         if rand() <=P
% %                 value = temp_value;
% %             end
% %         end
% % Positions(n,:)=value;
% % 
% %     end
% %     count = count + 1;
% %     enegy(count) =Fun(value);
% %     temperature=temperature*Tm(2);
% % 
% % end
% % fit=zeros(N,1);
% % for i=1:N
% %      fit(i,1)=Fun(Positions(i,:));
% % end
% % wbest = Positions; % Best position initialization
% % fitness=fit;
% % for j=1:N
% %         if fit(j)<=BestF
% %            BestF=fit(j);
% %            BestX=Positions(j,:);
% %         end
% % end
% % 
% % end
% % 
% % 
% % 
% % function Positions=initialization(SearchAgents_no,dim,ub,lb)
% % 
% % Boundary_no= size(ub,2); % numnber of boundaries
% % 
% % % If the boundaries of all variables are equal and user enter a signle
% % % number for both ub and lb
% % if Boundary_no==1
% %     Positions=rand(SearchAgents_no,dim).*(ub-lb)+lb;
% % end
% % 
% % % If each variable has a different lb and ub
% % if Boundary_no>1
% %     for i=1:dim
% %         ub_i=ub(i);
% %         lb_i=lb(i);
% %         Positions(:,i)=rand(SearchAgents_no,1).*(ub_i-lb_i)+lb_i;
% %     end
% % end
% % end
% % function [value] = Disturb(dim,lb,ub)
% % Boundary_no= size(ub,2); % numnber of boundaries
% % % If the boundaries of all variables are equal and user enter a signle
% % % number for both ub and lb
% % if Boundary_no==1
% %     value=rand(1,dim).*(ub-lb)+lb;
% % end
% % % If each variable has a different lb and ub
% % if Boundary_no>1
% %     for i=1:dim
% %         ub_i=ub(i);
% %         lb_i=lb(i);
% %         value(:,i)=rand(1,1).*(ub_i-lb_i)+lb_i;
% %     end
% % end
% % 
% % end
% 
% function [SAMRFO_Best_score, SAMRFO_curve] = SAMRFO(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj)
% % 参数映射
% nPop = pop_size;
% MaxIt = max_iter;
% Dim = variables_no;
% Low = lower_bound;
% Up = upper_bound;
% 
% % 初始化
% BestX = zeros(1, Dim);
% BestF = inf;
% SAMRFO_curve = zeros(1, MaxIt);
% 
% % --- 模拟退火初始化种群 ---
% % Tm(1): temperature, Tm(2): cooling rate, Tm(3): min temperature
% Tm = [max(Up), 0.95, 0.01];
% [PopFit, ~, PopPos, BestX] = simulatedAnnealing(fobj, nPop, Dim, Up, Low, Tm);
% BestF = min(PopFit);
% 
% % --- 主循环 ---
% for It = 1:MaxIt  
%     Coef = It / MaxIt; 
%     newPopPos = zeros(nPop, Dim);
%     newPopFit = zeros(1, nPop);
% 
%     % 1. 旋涡觅食阶段 (Chain Foraging)
%     for i = 1:nPop
%         if i == 1
%             prevPos = PopPos(1, :); % 对于第一个个体，参考点处理
%         else
%             prevPos = PopPos(i-1, :);
%         end
% 
%         if rand < 0.5
%             r1 = rand;                         
%             Beta = 2 * exp(r1 * ((MaxIt - It + 1) / MaxIt)) * (sin(2 * pi * r1));    
%             if Coef > rand                                                      
%                 newPopPos(i, :) = BestX + rand(1, Dim) .* (prevPos - PopPos(i, :)) + Beta * (BestX - PopPos(i, :));
%             else
%                 IndivRand = rand(1, Dim) .* (Up - Low) + Low;                                
%                 newPopPos(i, :) = IndivRand + rand(1, Dim) .* (prevPos - PopPos(i, :)) + Beta * (IndivRand - PopPos(i, :));
%             end              
%         else 
%             Alpha = 2 * rand(1, Dim) .* (-log(rand(1, Dim))).^0.5;           
%             newPopPos(i, :) = PopPos(i, :) + rand(1, Dim) .* (prevPos - PopPos(i, :)) + Alpha .* (BestX - PopPos(i, :));
%         end
%     end
% 
%     % 边界检查与位置更新
%     for i = 1:nPop        
%         newPopPos(i, :) = SpaceBound(newPopPos(i, :), Up, Low);
%         newPopFit(i) = fobj(newPopPos(i, :));    
%         if newPopFit(i) < PopFit(i)
%             PopFit(i) = newPopFit(i);
%             PopPos(i, :) = newPopPos(i, :);
%         end
%     end
% 
%     % 2. 翻滚觅食阶段 (Somersault Foraging)
%     S = 2;
%     for i = 1:nPop           
%         newPopPos(i, :) = PopPos(i, :) + S * (rand * BestX - rand * PopPos(i, :));
%         newPopPos(i, :) = SpaceBound(newPopPos(i, :), Up, Low);
%         newPopFit(i) = fobj(newPopPos(i, :));    
%         if newPopFit(i) < PopFit(i)
%             PopFit(i) = newPopFit(i);
%             PopPos(i, :) = newPopPos(i, :);
%         end
%     end
% 
%     % 更新全局最优
%     for i = 1:nPop
%         if PopFit(i) < BestF
%             BestF = PopFit(i);
%             BestX = PopPos(i, :);            
%         end
%     end
% 
%     SAMRFO_curve(It) = BestF;
% end
% 
% SAMRFO_Best_score = BestF;
% 
% end
% 
% % --- 辅助函数：边界约束 ---
% function X = SpaceBound(X, Up, Low)
%     Dim = length(X);
%     S = (X > Up) + (X < Low);    
%     X = (rand(1, Dim) .* (Up - Low) + Low) .* S + X .* (~S);
% end
% 
% % --- 辅助函数：模拟退火初始化 ---
% function [fitness, BestF, wbest, BestX] = simulatedAnnealing(Fun, N, dim, ub, lb, Tm)
%     Positions = initialization(N, dim, ub, lb);
%     BestF = inf; 
%     value = Disturb(dim, lb, ub);
%     temperature = Tm(1);
% 
%     while temperature > Tm(3)
%         for n = 1:N
%             enegy1 = Fun(value);
%             temp_value = Disturb(dim, lb, ub);
%             enegy2 = Fun(temp_value);
%             delta_e = enegy2 - enegy1;
%             if delta_e < 0
%                 value = temp_value;
%             else
%                 if rand() <= exp(-delta_e / temperature)
%                     value = temp_value;
%                 end
%             end
%             Positions(n, :) = value;
%         end
%         temperature = temperature * Tm(2);
%     end
% 
%     fit = zeros(N, 1);
%     for i = 1:N
%         fit(i) = Fun(Positions(i, :));
%     end
%     wbest = Positions;
%     fitness = fit;
%     [BestF, idx] = min(fit);
%     BestX = Positions(idx, :);
% end
% 
% % --- 辅助函数：初始化 ---
% function Positions = initialization(SearchAgents_no, dim, ub, lb)
%     if length(ub) == 1
%         Positions = rand(SearchAgents_no, dim) .* (ub - lb) + lb;
%     else
%         Positions = zeros(SearchAgents_no, dim);
%         for i = 1:dim
%             Positions(:, i) = rand(SearchAgents_no, 1) .* (ub(i) - lb(i)) + lb(i);
%         end
%     end
% end
% 
% % --- 辅助函数：扰动 ---
% function value = Disturb(dim, lb, ub)
%     if length(ub) == 1
%         value = rand(1, dim) .* (ub - lb) + lb;
%     else
%         value = zeros(1, dim);
%         for i = 1:dim
%             value(1, i) = rand * (ub(i) - lb(i)) + lb(i);
%         end
%     end
% end


function [ BestFit,Best_Score, Convergence_curve] = SAMRFO(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj)

% ================= 参数映射 =================
nPop = pop_size;
MaxIt = max_iter;
Dim = variables_no;
Low = lower_bound;
Up = upper_bound;

% ================= 初始化 =================
BestFit = zeros(1, Dim);
Best_Score = inf;
Convergence_curve = zeros(1, MaxIt);

% --- 模拟退火初始化 ---
Tm = [max(Up), 0.95, 0.01];
[PopFit, ~, PopPos, BestFit] = simulatedAnnealing(fobj, nPop, Dim, Up, Low, Tm);

Best_Score = min(PopFit);

% ================= 主循环 =================
for It = 1:MaxIt

    Coef = It / MaxIt;
    newPopPos = zeros(nPop, Dim);
    newPopFit = zeros(1, nPop);

    % ========= 1. Chain Foraging =========
    for i = 1:nPop

        if i == 1
            prevPos = PopPos(1, :);
        else
            prevPos = PopPos(i-1, :);
        end

        if rand < 0.5
            r1 = rand;
            Beta = 2 * exp(r1 * ((MaxIt - It + 1) / MaxIt)) * sin(2*pi*r1);

            if Coef > rand
                newPopPos(i, :) = BestFit + rand(1, Dim).*(prevPos - PopPos(i,:)) + Beta*(BestFit - PopPos(i,:));
            else
                IndivRand = rand(1, Dim).*(Up - Low) + Low;
                newPopPos(i,:) = IndivRand + rand(1, Dim).*(prevPos - PopPos(i,:)) + Beta*(IndivRand - PopPos(i,:));
            end

        else
            Alpha = 2 * rand(1, Dim) .* (-log(rand(1, Dim))).^0.5;
            newPopPos(i,:) = PopPos(i,:) + rand(1,Dim).*(prevPos - PopPos(i,:)) + Alpha.*(BestFit - PopPos(i,:));
        end

    end

    % ========= 边界 + 更新 =========
    for i = 1:nPop
        newPopPos(i,:) = SpaceBound(newPopPos(i,:), Up, Low);
        newPopFit(i) = fobj(newPopPos(i,:));

        if newPopFit(i) < PopFit(i)
            PopFit(i) = newPopFit(i);
            PopPos(i,:) = newPopPos(i,:);
        end
    end

    % ========= 2. Somersault =========
    S = 2;

    for i = 1:nPop
        newPopPos(i,:) = PopPos(i,:) + S*(rand*BestFit - rand*PopPos(i,:));
        newPopPos(i,:) = SpaceBound(newPopPos(i,:), Up, Low);

        newPopFit(i) = fobj(newPopPos(i,:));

        if newPopFit(i) < PopFit(i)
            PopFit(i) = newPopFit(i);
            PopPos(i,:) = newPopPos(i,:);
        end
    end

    % ========= 更新全局最优 =========
    for i = 1:nPop
        if PopFit(i) < Best_Score
            Best_Score = PopFit(i);
            BestFit = PopPos(i,:);
        end
    end

    Convergence_curve(It) = Best_Score;

end

end

% =========================================================
% 辅助函数
% =========================================================

function X = SpaceBound(X, Up, Low)
Dim = length(X);
S = (X > Up) + (X < Low);
X = (rand(1, Dim).*(Up-Low) + Low).*S + X.*(~S);
end

function [fitness, BestF, wbest, BestX] = simulatedAnnealing(Fun, N, dim, ub, lb, Tm)

Positions = initialization(N, dim, ub, lb);
BestF = inf;
value = Disturb(dim, lb, ub);
temperature = Tm(1);

while temperature > Tm(3)
    for n = 1:N
        e1 = Fun(value);
        temp_value = Disturb(dim, lb, ub);
        e2 = Fun(temp_value);

        delta_e = e2 - e1;

        if delta_e < 0
            value = temp_value;
        elseif rand() <= exp(-delta_e / temperature)
            value = temp_value;
        end

        Positions(n,:) = value;
    end
    temperature = temperature * Tm(2);
end

fit = zeros(N,1);
for i = 1:N
    fit(i) = Fun(Positions(i,:));
end

wbest = Positions;
fitness = fit;

[BestF, idx] = min(fit);
BestX = Positions(idx,:);

end

function Positions = initialization(N, dim, ub, lb)

if length(ub)==1
    Positions = rand(N,dim).*(ub-lb)+lb;
else
    Positions = zeros(N,dim);
    for i=1:dim
        Positions(:,i)=rand(N,1).*(ub(i)-lb(i))+lb(i);
    end
end

end

function value = Disturb(dim, lb, ub)

if length(ub)==1
    value = rand(1,dim).*(ub-lb)+lb;
else
    value = zeros(1,dim);
    for i=1:dim
        value(i)=rand*(ub(i)-lb(i))+lb(i);
    end
end

end