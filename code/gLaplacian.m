function L=gLaplacian(data,NN,t)
% Baseline graph Laplacian
    options = ml_options('GraphNormalize',1);
    options.NN=NN;
    options.GraphWeights = 'heat';
    options.GraphWeightParam = t;
    L = eigenlaplacian(data, options);
    L(isnan(L)|isinf(L))=0;
end