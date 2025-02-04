function stats = classificationFunc(features, label)

% shuffle data
% s=rng('default');
% randshuffle = randperm(length(features_CSP.Label));

% Classification data 
Train_Data = features;
Train_Label = label;


model = cell(1,5);
nModels = size(model,2);

model{1} = fitcsvm(Train_Data,Train_Label,'standardize',1,'KernelFunction','linear');
model{2} = fitctree(Train_Data,Train_Label,'MaxNumSplits',3);
model{3} = fitcsvm(Train_Data,Train_Label,'standardize',1,'KernelFunction', 'rbf','kernelscale','auto');
model{4} = fitcdiscr(Train_Data,Train_Label','DiscrimType','diaglinear');%'linear'
model{5} = fitcknn(Train_Data,Train_Label','NumNeighbors',5,'Standardize',1);

kfold = 10;
kfold_val = cell(1,nModels);
kfold_loss = zeros(nModels,kfold);

for k=1:nModels
    %         disp(['Models num: ',num2str(k)])
    kfold_val{k} = crossval(model{k},'kfold',kfold);
    kfold_loss(k,:) = kfoldLoss(kfold_val{k},'Mode','individual');
end

kfold_accu = 1-kfold_loss;
kfold_accu_avg = mean(kfold_accu,2)*100;

% output
stats.Kfold = kfold;
stats.kfold_loss = kfold_loss;
stats.kfold_accu = kfold_accu;
stats.kfold_accu_avg = kfold_accu_avg;


end