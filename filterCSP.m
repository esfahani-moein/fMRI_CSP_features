function CSPstructure = filterCSP(dataClass1,dataClass2,m)


%%
Rh=0;
for i=1:size(dataClass1,3)
    x1 = dataClass1(:,:,i);
    % step 1: normal data
    x1 = x1-repmat(mean(x1,2),1,size(x1,2));
    rh = (x1*x1')/trace(x1*x1');
    %     rh= (x1*x1')/sum(diag(x1*x1'));
    Rh = Rh+ rh;
end
% step2: calculate Rh and Rf mean
Rh= Rh / size(dataClass1,3);
%%

Rf=0;
for i=1:size(dataClass2,3)
    x2= dataClass2(:,:,i);
    % step 1: normal data
    x2=x2-repmat(mean(x2,2),1,size(x2,2));
    rf= (x2*x2')/trace(x2*x2');
    Rf = Rf+ rf;
end
% step2: calculate Rh and Rf mean
Rf= Rf / size(dataClass2,3);
%% generalized eigen value decomposition
[u1,v1] = eig(Rh,Rf);
v1 = diag(v1);
[~,ind1] = sort(v1,'descend');
u1 = u1(:,ind1);

[u2,v2] = eig(Rf,Rh);
v2 = diag(v2);
[~,ind2] = sort(v2,'descend');
u2 = u2(:,ind2);

mat = [u1(:,1:m) , u2(:,1:m) ]';

CSPstructure.CSP_Matrix = mat;
CSPstructure.dataClass1 = dataClass1;
CSPstructure.dataClass2 = dataClass2;
CSPstructure.nCh = size(dataClass1,1);
CSPstructure.nTimePoints = size(dataClass1,2);
end