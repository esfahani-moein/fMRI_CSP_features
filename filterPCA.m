function PCAstructure = filterPCA(dataClass1,dataClass2,m)
data1 = squeeze(mean(dataClass1,2))';
data2 = squeeze(mean(dataClass2,2))';

coeff1 = pca(data1, 'NumComponents', m);
coeff2 = pca(data2, 'NumComponents', m);
data_red1 = data1 * coeff1;
data_red2 = data2 * coeff2;

PCAstructure = vertcat(data_red1,data_red2);
% PCAstructure.dataClass2 = data_red2;
end