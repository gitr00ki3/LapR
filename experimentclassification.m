function [etSVM, etKNN]=experimentclassification(FILE, method, D, nn, t)
% An example of how to run experiment is included in runExperiment.m file.
% Returns SVM and KNN classifier errors 10 x number of distinct labels in
% data
% FILE- Give .mat file name containing
%   1. data- nxd format where n=#of observations and d=ambient dimension
%   2. label- nx1 containing respective labels(for dataDivision.m)
%   3. D- target dimension if explicitly D not passed to function or D=0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   4. train- index of training samples     |KINDLY USE ./code/dataDivision.m
%   5. test- index of testing observations  |code to generate these indices
%   6. y- labels of training samples        |for new dataset.
%   7. yt- labels of testing samples        |
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   8. NN- for kNN classifier
% method- method name lap, lap_ad, lle, isomap, ltsa
% nn- #of nearest neighborhood for methods other than lap_ad, for lap_ad
%     provide DELTA value as mentioned in paper.
% t- Parzen window for Laplacian, if not given or t=0, Silverman's rule of thumb
%    will be used.
    mapX=experimentnldr(FILE, method, D, nn, t);
    load(FILE,'datasets','NN');
    % Call the classifiers
    etSVM=[];
    etKNN=[];
    MAX=length(datasets);
    for i=1:MAX
        train=datasets(i).train; test=datasets(i).test;
        y=datasets(i).y; yt=datasets(i).yt;
        [etSVM(i,:), etKNN(i,:)]=customClassifiers(mapX,train,test,y,yt,NN);
    end
    etSVM=mean(etSVM); etKNN=mean(etKNN);
end