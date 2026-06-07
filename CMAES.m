% function [best, best_fit, curve] = CMAES(NP, max_iter, lb, ub, dim, fobj)
% 
% % ================= 参数初始化 =================
% mu = floor(NP/2);
% weights = log(mu + 0.5) - log(1:mu);
% weights = weights / sum(weights);
% 
% mu_eff = 1 / sum(weights.^2);
% 
% % learning rates
% c_sigma = (mu_eff + 2) / (dim + mu_eff + 5);
% d_sigma = 1 + 2*max(0, sqrt((mu_eff-1)/(dim+1)) - 1) + c_sigma;
% 
% c_c = (4 + mu_eff/dim) / (dim + 4 + 2*mu_eff/dim);
% c1 = 2 / ((dim + 1.3)^2 + mu_eff);
% c_mu = min(1 - c1, 2*(mu_eff-2+1/mu_eff)/((dim+2)^2 + mu_eff));
% 
% % ================= 初始化 =================
% xmean = lb + (ub-lb).*rand(1,dim);
% sigma = 0.3 * (ub - lb);
% 
% C = eye(dim);
% pc = zeros(dim,1);
% ps = zeros(dim,1);
% 
% eigeneval = 0;
% chiN = dim^0.5 * (1 - 1/(4*dim) + 1/(21*dim^2));
% 
% best_fit = inf;
% best = xmean;
% 
% curve = zeros(max_iter,1);
% 
% % ================= 主循环 =================
% for t = 1:max_iter
% 
%     % ===== 特征分解（控制频率）=====
%     if t - eigeneval > NP/(c1+c_mu)/dim
%         eigeneval = t;
%         C = triu(C) + triu(C,1)'; % 保证对称
%         [B, D] = eig(C);
%         D = sqrt(diag(D));
%     end
% 
%     % ===== 生成子代 =====
%     arz = randn(NP, dim);
%     ary = arz * (B .* D')';
%     arx = xmean + sigma * ary;
% 
%     % 边界处理
%     arx = max(arx, lb);
%     arx = min(arx, ub);
% 
%     fitness = zeros(NP,1);
%     for i = 1:NP
%         fitness(i) = fobj(arx(i,:));
%     end
% 
%     % ===== 排序 =====
%     [fitness, idx] = sort(fitness);
%     arx = arx(idx,:);
% 
%     % ===== 更新最优 =====
%     if fitness(1) < best_fit
%         best_fit = fitness(1);
%         best = arx(1,:);
%     end
% 
%     % ===== 加权均值 =====
%     xold = xmean;
%     xmean = weights * arx(1:mu,:);
% 
%     % ===== 更新进化路径 ps =====
%     y = (xmean - xold) / sigma;
%     ps = (1 - c_sigma) * ps + sqrt(c_sigma*(2-c_sigma)*mu_eff) * (B * (y./D));
% 
%     % ===== step-size 更新 =====
%     sigma = sigma * exp((c_sigma/d_sigma) * (norm(ps)/chiN - 1));
% 
%     % ===== hsig =====
%     hsig = norm(ps)/sqrt(1 - (1-c_sigma)^(2*t)) < (1.4 + 2/(dim+1))*chiN;
% 
%     % ===== 更新 pc =====
%     pc = (1 - c_c)*pc + hsig*sqrt(c_c*(2-c_c)*mu_eff)*y;
% 
%     % ===== 更新协方差矩阵 =====
%     artmp = (arx(1:mu,:) - repmat(xold,mu,1)) / sigma;
% 
%     C = (1 - c1 - c_mu)*C ...
%         + c1*(pc*pc') ...
%         + c_mu * artmp' * diag(weights) * artmp;
% 
%     % ===== 记录收敛 =====
%     curve(t) = best_fit;
% 
% end
% 
% end

% function [best, best_fit, curve] = CMAES(NP, max_iter, lb, ub, dim, fobj)
% 
% % ================= 初始化 =================
% mu = floor(NP/2);
% 
% weights = log(mu + 0.5) - log(1:mu);
% weights = weights / sum(weights);
% 
% mu_eff = 1 / sum(weights.^2);
% 
% % learning rates
% c_sigma = (mu_eff + 2) / (dim + mu_eff + 5);
% d_sigma = 1 + 2*max(0, sqrt((mu_eff-1)/(dim+1)) - 1) + c_sigma;
% 
% c_c = (4 + mu_eff/dim) / (dim + 4 + 2*mu_eff/dim);
% c1 = 2 / ((dim + 1.3)^2 + mu_eff);
% c_mu = min(1 - c1, 2*(mu_eff-2+1/mu_eff)/((dim+2)^2 + mu_eff));
% 
% % ================= 初始化种群 =================
% xmean = lb + (ub - lb).*rand(1,dim);
% sigma = 0.3 * (ub - lb);
% 
% C = eye(dim);
% pc = zeros(dim,1);
% ps = zeros(dim,1);
% 
% chiN = dim^0.5 * (1 - 1/(4*dim) + 1/(21*dim^2));
% 
% best_fit = inf;
% best = xmean;
% 
% curve = zeros(max_iter,1);
% 
% % ===== 初始化特征分解 =====
% [B, D] = eig(C);
% D = sqrt(diag(D));
% 
% eigeneval = 0;
% 
% % ================= 主循环 =================
% for t = 1:max_iter
% 
%     % ===== 更新分解（控制频率）=====
%     if t - eigeneval > NP/(c1 + c_mu)/dim
%         eigeneval = t;
% 
%         C = triu(C) + triu(C,1)'; % 保证对称
%         [B, D] = eig(C);
%         D = sqrt(max(diag(D), 1e-20)); % 防止负特征值
%     end
% 
%     % ================= 生成子代 =================
%     arz = randn(NP, dim);
% 
%     % ✔ 稳定采样
%     ary = arz * (B * diag(D))';
% 
%     arx = xmean + sigma * ary;
% 
%     % ================= 边界处理 =================
%     arx = min(max(arx, lb), ub);
% 
%     % ================= 计算适应度 =================
%     fitness = zeros(NP,1);
% 
%     for i = 1:NP
%         fx = fobj(arx(i,:));
% 
%         % ✔ 防 NaN / Inf
%         if isnan(fx) || isinf(fx)
%             fx = 1e30;
%         end
% 
%         fitness(i) = fx;
%     end
% 
%     % ================= 排序 =================
%     [fitness, idx] = sort(fitness);
%     arx = arx(idx,:);
% 
%     % ================= 更新最优 =================
%     if fitness(1) < best_fit
%         best_fit = fitness(1);
%         best = arx(1,:);
%     end
% 
%     % ================= 更新均值 =================
%     xold = xmean;
%     xmean = weights * arx(1:mu,:);
% 
%     % ================= evolution path =================
%     y = (xmean - xold) / sigma;
% 
%     ps = (1 - c_sigma)*ps + sqrt(c_sigma*(2-c_sigma)*mu_eff) * (B * (y ./ D));
% 
%     % ================= step size =================
%     sigma = sigma * exp((c_sigma/d_sigma) * (norm(ps)/chiN - 1));
% 
%     % ================= hsig =================
%     hsig = norm(ps)/sqrt(1 - (1-c_sigma)^(2*t)) < (1.4 + 2/(dim+1))*chiN;
% 
%     % ================= covariance update =================
%     pc = (1 - c_c)*pc + hsig*sqrt(c_c*(2-c_c)*mu_eff)*y;
% 
%     artmp = (arx(1:mu,:) - repmat(xold,mu,1)) / sigma;
% 
%     C = (1 - c1 - c_mu)*C ...
%         + c1*(pc*pc') ...
%         + c_mu * artmp' * diag(weights) * artmp;
% 
%     % ================= 数值稳定 =================
%     C = (C + C')/2; % 强制对称
%     C = C + 1e-10*eye(dim); % 防退化
% 
%     % ================= 记录 =================
%     curve(t) = best_fit;
% 
% end
% 
% end

function [ best_solution,best_fitness, curve_CMAES] = CMAES(pop_size, max_iter, lower_bound, upper_bound, variables_no, fobj)
    %% 1. 参数对齐与初始化
    NP = pop_size;
    dim = variables_no;
    lb = lower_bound;
    ub = upper_bound;
    
    % 确保边界为行向量
    if length(lb) == 1
        lb = lb * ones(1, dim);
        ub = ub * ones(1, dim);
    end

    % CMA-ES 策略参数设置
    mu = floor(NP/2);               % 选择权重个体的数量
    weights = log(mu + 0.5) - log(1:mu);
    weights = weights / sum(weights); % 归一化权重
    mu_eff = 1 / sum(weights.^2);     % 方差有效选择量
    
    % 学习率与参数更新常数
    c_sigma = (mu_eff + 2) / (dim + mu_eff + 5);
    d_sigma = 1 + 2*max(0, sqrt((mu_eff-1)/(dim+1)) - 1) + c_sigma;
    c_c = (4 + mu_eff/dim) / (dim + 4 + 2*mu_eff/dim);
    c1 = 2 / ((dim + 1.3)^2 + mu_eff);
    c_mu = min(1 - c1, 2*(mu_eff-2+1/mu_eff)/((dim+2)^2 + mu_eff));
    
    % 状态变量初始化
    xmean = lb + (ub - lb).*rand(1, dim); 
    sigma = 0.3 * max(ub - lb);           % 初始步长
    C = eye(dim);                         % 协方差矩阵
    pc = zeros(dim, 1);                   % 演化路径
    ps = zeros(dim, 1);                   % 共轭演化路径
    chiN = dim^0.5 * (1 - 1/(4*dim) + 1/(21*dim^2)); 
    
    best_fitness = inf;
    best_solution = xmean;
    curve_CMAES = zeros(max_iter, 1);
    
    % 初始化特征分解
    [B, D_mat] = eig(C);
    D = sqrt(diag(D_mat));
    eigeneval = 0;

    %% 2. 主循环
    for t = 1:max_iter
        % 更新特征分解（控制更新频率）
        if t - eigeneval > NP/(c1 + c_mu)/dim/10
            eigeneval = t;
            C = triu(C) + triu(C,1)'; % 保证对称
            [B, D_mat] = eig(C);
            D = sqrt(max(diag(D_mat), 1e-20)); 
        end
        
        % ================= 生成子代 =================
        arz = randn(NP, dim);               
        ary = arz * (B * diag(D))';         
        arx = repmat(xmean, NP, 1) + sigma * ary; 
        
        % ================= 边界处理 =================
        LB_mat = repmat(lb, NP, 1);
        UB_mat = repmat(ub, NP, 1);
        arx = max(min(arx, UB_mat), LB_mat);
        
        % ================= 计算适应度 =================
        fitness = zeros(NP, 1);
        for i = 1:NP
            fx = fobj(arx(i,:));
            if isnan(fx) || isinf(fx)
                fx = 1e30;
            end
            fitness(i) = fx;
        end
        
        % ================= 排序与选择 =================
        [fitness, idx] = sort(fitness);
        arx = arx(idx, :);
        
        % 更新全局最优
        if fitness(1) < best_fitness
            best_fitness = fitness(1);
            best_solution = arx(1, :);
        end
        
        % ================= 更新均值 =================
        xold = xmean;
        xmean = weights * arx(1:mu, :); 
        
        % ================= 演化路径更新 =================
        y = (xmean - xold) / sigma;
        ps = (1 - c_sigma)*ps + sqrt(c_sigma*(2-c_sigma)*mu_eff) * (B * (y' ./ D));
        sigma = sigma * exp((c_sigma/d_sigma) * (norm(ps)/chiN - 1));
        
        hsig = norm(ps)/sqrt(1 - (1-c_sigma)^(2*t)) < (1.4 + 2/(dim+1))*chiN;
        pc = (1 - c_c)*pc + hsig*sqrt(c_c*(2-c_c)*mu_eff)*y';
        
        % ================= 协方差矩阵更新 =================
        artmp = (arx(1:mu,:) - repmat(xold, mu, 1)) / sigma;
        C = (1 - c1 - c_mu)*C ...
            + c1*(pc*pc') ...
            + c_mu * artmp' * diag(weights) * artmp;
        
        % 数值稳定性控制
        C = (C + C')/2;
        if mod(t, 10) == 0
            C = C + 1e-10 * eye(dim); 
        end
        
        % 记录收敛曲线
        curve_CMAES(t) = best_fitness;
    end
end