load ClassificationResults_v7.mat
index=[1,4,3,5,2,6];
errsvm=[];errknn=[];
for i=1:length(rmserror)
    if isempty(rmserror(index(i)).dname)
        continue;
    end
    errsvm=[errsvm mean(rmserror(index(i)).errSVM,2) std(rmserror(index(i)).errSVM,0,2)];
    errknn=[errknn mean(rmserror(index(i)).errKNN,2) std(rmserror(index(i)).errKNN,0,2)];
end
%%
[r,c]=size(errsvm);
tbs={'\multirow{2}{*}{\lapr}';'';...
    '\multirow{2}{*}{LE}';'';...
    '\multirow{2}{*}{LLE}';'';...
    '\multirow{2}{*}{Isomap}';'';...
    '\multirow{2}{*}{LTSA}';'';...
    '\multirow{2}{*}{EMR24}';'';...
    '\multirow{2}{*}{EMR72}';'';...
    '\multirow{2}{*}{MMM}';'';...
    '\multirow{2}{*}{K\textsubscript{7}}';'';...
    '\multirow{2}{*}{RP}';'';};
tbk=tbs;
[~,minS]=min(errsvm);
[~,minK]=min(errknn);
for i=1:2:c
    k=1;
    for j=1:r
        t=num2str(errsvm(j,i), '%.3f');
        if (j==minS(i))
            t=['{\bfseries ' t '}'];
        end
        tbs{k}=[tbs{k} ' & ' t];
        t=num2str(errsvm(j,i+1), '%.3f');
        tbs{k+1}=[tbs{k+1} ' & $ \pm $' t];
        
        t=num2str(errknn(j,i), '%.3f');
        if (j==minK(i))
            t=['{\bfseries ' t '}'];
        end
        tbk{k}=[tbk{k} ' & ' t];
        t=num2str(errknn(j,i+1), '%.3f');
        tbk{k+1}=[tbk{k+1} ' & $ \pm $' t];
        
        k=k+2;
    end
end
a=repmat({'\\';'\\\hline'},10,1);
tbs=[tbs a];
tbk=[tbk a];