close all;clear;clc;
fname='ClassificationResults_v5.mat';
dfile={'5F_SubjectA.mat','HaLT_SubjectA.mat','Hasy_v2.mat','NaturalImage.mat'};
methods={'lap_ad','lap','lle','isomap','ltsa'};
D=[30 30 7 28];
DELTA=[5e-3 795e-3 5e-2 5e-1];
NN=[18 24 18 20];
%%
if ~exist('rmserror','var')
    rmserror=struct();
end
for i=1:length(dfile)
    if ~exist(dfile{i},'file')
        error([dfile{i} ' does not exists']);
    end
    rmserror(i).dname=dfile{i};
    errSVM=[];errKNN=[];
    for j=1:length(methods)
        nn=((j==1)*DELTA(i))+(~(j==1)*NN(i));
        [errSVM(j,:), errKNN(j,:)]=experimentclassification(dfile{i},...
            methods{j},D(i),nn,0);
    end
    rmserror(i).errSVM=errSVM;
    rmserror(i).errKNN=errKNN;
end
if ~exist(fname,'file')
    save(fname,'rmserror');
else
    save(fname,'rmserror','-append');
end