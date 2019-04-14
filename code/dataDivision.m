tmp=unique(label);
datasets=struct();
MAX=10;
for j=1:MAX
    train=[];test=[];y=[];yt=[];
    for i=1:length(tmp)
        lbl=find(label==tmp(i));
        tlbl=rand(length(lbl),1);
        train=[train;lbl(tlbl<=0.7)];
        y=[y;label(lbl(tlbl<=0.7))];
        test=[test;lbl(tlbl>=0.5)];
        yt=[yt;label(lbl(tlbl>=0.5))];
    end
    disp(unique(y)');
    datasets(j).train=train;
    datasets(j).test=test;
    datasets(j).y=y;
    datasets(j).yt=yt;
end
clearvars -except datasets data label;
cd ..;