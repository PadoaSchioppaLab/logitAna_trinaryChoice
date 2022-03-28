% function [beta, hf] = logitAna_trinaryChoices()
%
% This script performes a logistic analysis of trinary choices on an
% example session in which a monkey chosen between 3 juices ABC. The script
% callse the function objectiveFun_logit3 and returns the following beta:
% beta(1) = beta0_A		% => rhoA
% beta(2) = beta0_B		% => rhoB
% beta(3) = beta1		% => gamma = probability distortion; risk attitide
% beta(4) = beta2		% = eta; inverse temperature
%
% The analysis is described in:
% Padoa-Schioppa C, Logistic analysis of choice data: A primer, Neuron, 2022
% 
% Two figures illustrate all trials and the results of the analysis
% 

%
% Author: Camillo,	March 2020
% Revised:			February 2021
% 

clear all	%#ok<CLALL>

load exampleSession_data.mat

%recover parameters, PP, QQ and choices
ntrials = size(goodTrials,1);
aux = reshape([sessionParams.goods.quantRange],2,3);
qmax = aux(2,:);	%max quantities for the 3 juices
QQ = goodTrials(:,2:4);
PP = goodTrials(:,5:7);

%complicated way to pass data to the objective function...
!del sessionData_trinary_pq.mat
clear XX
XX(:,:,1) = PP;			%probabilities
XX(:,:,2) = QQ;			%quantities
YY = goodTrials(:,11);	%choices
save sessionData_trinary_pq XX YY

%plot offer distributions
figure, set(gcf, 'position',[265 750 1300 350], 'PaperPositionMode','auto')
%
subplot(1,3,1), hold on
gscatter(QQ(:,1), PP(:,1), YY, 'rbg', 'ooo');
axis([0 ceil(max(QQ(:,1))) 0 1])
title('offer A'), xlabel('qA'), ylabel('pA')
legend({'A chosen','B chosen','C chosen'}, 'location','southwest')
%
subplot(1,3,2), hold on
gscatter(QQ(:,2), PP(:,2), YY, 'rbg', 'ooo');
axis([0 ceil(max(QQ(:,2))) 0 1])
title('offer B'), xlabel('qB'), ylabel('pB')
legend off
%
subplot(1,3,3), hold on
gscatter(QQ(:,3), PP(:,3), YY, 'rbg', 'ooo');
axis([0 ceil(max(QQ(:,3))) 0 1])
title('offer C'), xlabel('qC'), ylabel('pC')
legend off

%home-made logistic regression
beta_init = [0,0,1,1];
[beta, fval, exitflag, output] = fminsearch(@objectiveFun_logit3, beta_init); 

%
rhoA = exp(beta(1)/beta(4));
rhoB = exp(beta(2)/beta(4));
gamma_fitted = beta(3)/beta(4);

%expevted values
EEVV = (QQ.*(ones(ntrials,1)*[rhoA,rhoB,1])) .* (PP.^gamma_fitted);

% prepare for simplex plots
xx = EEVV./(ones(ntrials,1).*max(EEVV));			%EV ranks
xy = [(2*xx(:,2)+xx(:,3))/2, sqrt(3)/2*xx(:,3)]./(sum(xx,2)*ones(1,2));

%colors according to EEVV
clrs = xx(:,[1,3,2]);

%plot session results in 3D, colors according to exp values
hf(1,1) = figure; set(gcf,'position',[680 435 560 660], 'PaperPositionMode','auto')
%
for itr = 1:ntrials
	plot3(EEVV(itr,1),EEVV(itr,2),EEVV(itr,3),'.','markersize',8,'color',clrs(itr,:));
	hold on
end
axis equal, grid on
scale = 2*ceil(max(EEVV)/2);
set(gca, 'xtick',0:2:scale(1), 'ytick',0:2:scale(2), 'ztick',0:2:scale(3))
xlabel('EVA'), ylabel('EVB'), zlabel('EVC')

%simplex plots
hf(1,2) = figure; set(gcf,'position',[430 95 810 1000], 'PaperPositionMode','auto')

%report results of logistic fit
text(.5,-.3,['\rho_{A} = ',	sprintf('%1.1f',rhoA)])
text(.5,-.5,['\rho_{B} = ',	sprintf('%1.1f',rhoB)])
text(.5,-.7,['  \gamma = ',	sprintf('%1.1f',gamma_fitted)])
text(.5,-.9,['  \eta = ',	sprintf('%1.1f',beta(4))])
axis off

%plot session results, colors according to exp values
axes('position',[.1 .66 .8 .3]); hold on
for itr = 1:ntrials
	plot(xy(itr,1),xy(itr,2),'.','markersize',8,'color',clrs(itr,:));
end
axis equal
axis([0 1 0 sqrt(3)/2]+[-.1 .1 -.1 .1])
axis off
text(-.1,.7,			'colors: exp values')
text(-.05,-.05,			['A=',num2str(qmax(1))])
text( .95,-.05,			['B=',num2str(qmax(2))])
text(.45,sqrt(3)/2+.05,	['C=',num2str(qmax(3))])

%plot session results, colors according to choices
axes('position',[.1 .34 .8 .3]); hold on
ii = YY==1; plot(xy(ii,1),xy(ii,2),'r.','markersize',8)
ii = YY==2; plot(xy(ii,1),xy(ii,2),'b.','markersize',8)
ii = YY==3; plot(xy(ii,1),xy(ii,2),'g.','markersize',8)
axis equal
axis([0 1 0 sqrt(3)/2]+[-.1 .1 -.1 .1])
axis off
text(-.1,.7,			'colors: chosen juice')
text(-.05,-.05,			['A=',num2str(qmax(1))])
text( .95,-.05,			['B=',num2str(qmax(2))])
text(.45,sqrt(3)/2+.05,	['C=',num2str(qmax(3))])

%plot session results, colors according to gotj
axes('position',[.1 .02 .8 .3]); hold on
gotj = logical(goodTrials(:,13));
plot(xy(~gotj,1),xy(~gotj,2),'.','markersize',8, 'color',.7*ones(1,3));
plot(xy( gotj,1),xy( gotj,2),'.','markersize',8, 'color',.2*ones(1,3));
axis equal
axis([0 1 0 sqrt(3)/2]+[-.1 .1 -.1 .1])
axis off
%
text(-.1,.7,			'colors: got juice')
text(-.05,-.05,			['A=',num2str(qmax(1))])
text( .95,-.05,			['B=',num2str(qmax(2))])
text(.45,sqrt(3)/2+.05,	['C=',num2str(qmax(3))])

