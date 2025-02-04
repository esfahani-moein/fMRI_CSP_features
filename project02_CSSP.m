clear
clc
close all
%% Load Data
% loading Dataset
% schizophrenia dataset
% Gender (1=female), Age, SZ diagnosis; mean frame displacement
% 314 subjects
dir_path = 'C:\datasets\FBIRN Classic\Data\';

% diagnostic status -- 1s are patients, the 0s are controls
fileNameSubDEMO = 'SubDEMO.mat';
load(strcat(dir_path,fileNameSubDEMO));

diag_status = SubDEMO(:,3);

% group ICA
% 47 "good" components -> a subject-specific timeseries
% 1081 = 47*46/2 unique network pairs

% fileNameFBcmpLabs = 'FBcmpLabs.mat';
% load(strcat(dir_path,fileNameFBcmpLabs));

% 47 x 159 x 314 (components x time x subjects)
fileNameFBsubjectTCs = 'FBsubjectTCs.mat';
load(strcat(dir_path,fileNameFBsubjectTCs));

%% Data Segmentation

Label = diag_status;
Dataset = FBsubjectTCs;
lbl1 = find(Label); % patients
lbl2 = find(~Label);

dataClass1 = zeros(size(Dataset,1), size(Dataset,2), length(lbl1));
dataClass2 = zeros(size(Dataset,1), size(Dataset,2), length(lbl2));


for i=1:length(lbl1)
        dataClass1(:,:,i) = Dataset(:,:,lbl1(i));
end

for j=1:length(lbl2)
        dataClass2(:,:,j) = Dataset(:,:,lbl2(j));
end

%% CSSP Transform Matrix
idx = 1:1:10;
results = cell(3,numel(idx));

for i =1:numel(idx)

    nbFilters = idx(i);  % output features are 2x
    tau = 3;
    CSSP_data = filterCSSP(dataClass1,dataClass2,nbFilters,tau);

%% Feature Extraction

    Features1 = zeros(length(Label),size(CSSP_data.CSSP_Matrix,1));
    Features2 = zeros(length(Label),size(CSSP_data.CSSP_Matrix,1));
    Features_raw = zeros(size(CSSP_data.CSSP_Matrix,1),2*CSSP_data.nTimePoints, length(Label));

    for k=1:length(Label)
        x1 = Dataset(:,:,k)';
    
        % x1 = [x1(:,1:end-tau),x1(:,tau+1:end)];
        x1 = [x1(:,1:end-tau);x1(:,tau+1:end)]';
    
        xx = CSSP_data.CSSP_Matrix*x1;
        Features_raw(:,:,k) = xx;
    
        Features1(k,:) = var(xx,0,2);
        Features2(k,:) = log10(var(xx,0,2)./sum(var(xx,0,2)));
    end
    results{1,i} = Features1;
    results{2,i} = Features2;
    results{3,i} = CSSP_data;
end

%% Save Results
file_path = fullfile('results', 'results_CSSP_tau3.mat');
save(file_path,"results")
