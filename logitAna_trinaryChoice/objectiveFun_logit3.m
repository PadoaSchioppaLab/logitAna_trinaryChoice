function FF = objectiveFun_logit3(beta)
%
% home-made logistic analysis for ternary choices
%

%
% author; CPS, March 2020
%



load('sessionData_trinary_pq','XX','YY')
PP = XX(:,:,1);
QQ = XX(:,:,2);

%remove forced choices; compute pp = log([pB/pA, pC/pB, pA/pC]) and qq = log([qB/qA, qC/qB, qA/qC])
ii = ~~prod (QQ,2);
pp = log([PP(ii,2)./PP(ii,1), PP(ii,3)./PP(ii,2), PP(ii,1)./PP(ii,3)]);
qq = log([QQ(ii,2)./QQ(ii,1), QQ(ii,3)./QQ(ii,2), QQ(ii,1)./QQ(ii,3)]);
yy = YY(ii,:);

iiA = yy==1;
iiB = yy==2;
iiC = yy==3;

FF = 0;
for jj = find(iiA)'
	FF = FF + log(1 + exp(-beta(1)+beta(2)+beta(3)*pp(jj,1)+beta(4)*qq(jj,1)) + exp(-beta(1)-beta(3)*pp(jj,3)-beta(4)*qq(jj,3)));
end
for jj = find(iiB)'
	FF = FF + log(1 + exp( beta(1)-beta(2)-beta(3)*pp(jj,1)-beta(4)*qq(jj,1)) + exp(-beta(2)+beta(3)*pp(jj,2)+beta(4)*qq(jj,2)));
end
for jj = find(iiC)'
	FF = FF + log(1 + exp( beta(1)+beta(3)*pp(jj,3)+beta(4)*qq(jj,3)) + exp( beta(2)-beta(3)*pp(jj,2)-beta(4)*qq(jj,2)));
end


