function CSSPstructure = filterCSSP(dataClass1,dataClass2,m,tau)


%%
Rh=0;
for i=1:size(dataClass1,3)
    x1 = dataClass1(:,:,i)';
    x1= [x1(:,1:end-tau);x1(:,tau+1:end)];
    % step 1: normal data
    x1 = x1-repmat(mean(x1,2),1,size(x1,2));
    x1 = x1';
    rh = (x1*x1')/trace(x1*x1');
    %     rh= (x1*x1')/sum(diag(x1*x1'));
    Rh = Rh+ rh;
end
% step2: calculate Rh and Rf mean
Rh= Rh / size(dataClass1,3);
%%

Rf=0;
for i=1:size(dataClass2,3)
    x2= dataClass2(:,:,i)';
    x2= [x2(:,1:end-tau);x2(:,tau+1:end)];
    % step 1: normal data
    x2=x2-repmat(mean(x2,2),1,size(x2,2));
    x2 = x2';
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

CSSPstructure.CSSP_Matrix = mat;
CSSPstructure.dataClass1 = dataClass1;
CSSPstructure.dataClass2 = dataClass2;
CSSPstructure.nCh = size(dataClass1,1);
CSSPstructure.nTimePoints = size(dataClass1,2);
end