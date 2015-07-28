%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this script computes the mean-diversification efficient frontier
% see A. Meucci - "Managing Diversification", Risk Magazine, June 2009
% available at www.ssrn.com

% Code by A. Meucci. This version March 2009. 
% Last version available at MATLAB central as "Managing Diversification"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% upload returns covariance and expectations
load Data

% define benchmark and portfolio weights
N=length(Mu);
w_0=ones(N,1)/N;

% define constraints
Constr.A=[eye(N) % long-short constraints...
    -eye(N)];
Constr.b=[1*ones(N,1)
    .1*ones(N,1)];
Constr.Aeq=ones(1,N); % budget constraint...
Constr.beq=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean-diversification analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mean-diversification frontier
[w,Ne_s,R_2_s,m_s,s_s]=MeanTCEntropyFrontier(S,Mu,w_b,w_0,Constr);


% mean-diversification of current allocation (Fig 2 in article)
m=Mu'*(w_0-w_b);
s=sqrt((w_0-w_b)'*S*(w_0-w_b));
[E,L,G]=GenPCBasis(S,[]);
v_tilde=G*(w_0-w_b);
TE_contr=(v_tilde.*v_tilde)/s;
R_2=max(10^(-10),TE_contr/sum(TE_contr));
Ne=exp(-R_2'*log(R_2));

figure;
subplot(3,1,1);
bar(-1*inv(E)*(w_0-w_b));
subplot(3,1,2)
bar(sqrt(L))
subplot(3,1,3);
bar(cumsum(TE_contr));

figure; % figure 6
plot(Ne_s,m_s,'o-')
hold on;
plot(Ne,m,'sr','MarkerFaceColor','r')
highlightaxes
title('Efficient Frontier')
figure; % figure 6 (diversification)
plot(cumsum(R_2_s(:,1)),'o')
hold on;
plot(cumsum(R_2_s(:,end)),'ro');
legend('MaxExp','MaxEntopy')


