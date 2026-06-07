function [xmin,fmin,histout] = GQPSO(fun,D,nPop,lb,ub,maxit,maxeval)

% INPUT:
%   fun     : function handle for optimization
%   D       : problem dimension (number of variables)
%   nPop    : number of particles in the swarm
%   lb      : lower bound constrain
%   ub      : upper bound constrain
%   maxit   : max number of iterations
%   maxeval : max number of function evaluations

% OUTPUT:
%   xmin    : best solution found
%   fmin    : function value at the best solution, f(xmin)
%   histout : record of function evaluations and fitness value by iteration

% EXAMPLE:

% fun = @griewankfcn;
% D = 30;
% nPop = 50;
% lb = -600;
% ub = 600;
% maxit = 1000;
% maxeval = 10000*D;

% [xmin,fmin,histout] = GQPSO(fun,D,nPop,lb,ub,maxit,maxeval);

% OR DIRECTLY:

% [xmin,fmin,histout] = GQPSO(@griewankfcn,30,50,-600,600,1000,10000*30);

% QPSO parameters:
w1 = 0.5;
w2 = 1.0;

c1 = 1.5;
c2 = 1.5;

% Initializing solution
x = unifrnd(lb,ub,[nPop,D]);

% Evaluate initial population
pbest = x;

histout = zeros(maxit,2);

f_x = feval(fun,x);

fval = nPop;

f_pbest = f_x;

[~,g] = min(f_pbest);
gbest = pbest(g,:);
f_gbest = f_pbest(g);

it = 1;

histout(it,1) = fval;
histout(it,2) = f_gbest;

while it < maxit && fval < maxeval

    alpha = (w2 - w1) * (maxit - it)/maxit + w1;
    mbest = sum(pbest)/nPop;

    for i = 1:nPop

        fi = abs(randn(1,D)); % Gaussian QPSO (Coelho, 2010)

        p = (c1*fi.*pbest(i,:) + c2*(1-fi).*gbest)/(c1 + c2);

        u = abs(randn(1,D));  % Gaussian QPSO (Coelho, 2010)
        
        b = alpha*abs(x(i,:) - mbest);
        v = log(1./u);

        if rand < 0.5
            x(i,:) = p + b .* v;
        else
            x(i,:) = p - b .* v;
        end
        
        % Keeping bounds
        x(i,:) = max(x(i,:),lb);
        x(i,:) = min(x(i,:),ub);

        f_x(i) = fun(x(i,:));
        
        fval = fval + 1;

        if f_x(i) < f_pbest(i)
            pbest(i,:) = x(i,:);
            f_pbest(i) = f_x(i);
        end

        if f_pbest(i) < f_gbest
            gbest = pbest(i,:);
            f_gbest = f_pbest(i);
        end

    end
    
    it = it + 1;

    histout(it,1) = fval;
    histout(it,2) = f_gbest;

end

xmin = gbest; 
fmin = f_gbest;

histout(it+1:end,:) = [];

figure
semilogy(histout(:,1),histout(:,2))
title('Gaussian Q-PSO')
xlabel('Function evaluations')
ylabel('Fitness')
grid on

end