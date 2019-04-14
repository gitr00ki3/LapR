%% SVM and kNN classifier
function [err_svm, err_knn]=customClassifiers(mapX,train,test,y,yt,NN)
labels = unique(y);
err_svm = zeros(1,length(labels));
err_knn = zeros(1,length(labels));
mapXl = mapX(train, :);
mapXt = mapX(test, :);
for i =1:length(labels)
    indx = y==labels(i);
    ytmp = y;
    ytmp(indx) = 1;
    ytmp(~indx) = -1;
    mdl_svm = fitcsvm(mapXl,ytmp,'KernelFunction','rbf',...
        'Standardize',true);
    mdl_knn = fitcknn(mapXl,ytmp,'NumNeighbors',NN,...
        'Standardize',1);
    
    yt_svm = predict(mdl_svm,mapXt);
    yt_knn = predict(mdl_knn,mapXt);
    indx = yt==labels(i);
    ytmp = yt;
    ytmp(indx) = 1;
    ytmp(~indx) = -1;
    
    err_svm(1,i)=(sum(yt_svm~=ytmp)/length(yt)*100);
    err_knn(1,i)=(sum(yt_knn~=ytmp)/length(yt)*100);
end