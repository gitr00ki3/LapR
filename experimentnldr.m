function mapX=experimentnldr(FILE, method, D, nn, t)
% FILE- Give .mat file name containing
%   1. data- nxd format where n=#of observations and d=ambient dimension
%   2. D- target dimension if explicitly D not passed to function or D=0
% method- method name lap, lap_ad, lle, isomap, ltsa
% nn- #of nearest neighborhood for methods other than lap_ad, for lap_ad
%     provide DELTA value as mentioned in paper.
% t- Parzen window for Laplacian, if not given or t=0, Silverman's rule of thumb
%    will be used.
	warning('off')
    if exist('D','var') && D>0
        load(FILE,'data');
    else
        load(FILE,'data','D'); % loads the mat file
    end
    switch method
        case 'lap'
            % Vanilla Laplacian with t Parzen window
            if ~exist('t','var') || t==0
                t = 1.06*mean(std(data))*nthroot(size(data,1),5);
            end
            L=gLaplacian(data,nn,t);
            [mapX, ~] = eigs(sparse(L),D+1,'sm');
            mapX = mapX(:,2:end);
        case 'lap_ad'
            % Adaptive Laplacian
            L=adLaplacian(data,nn);
            [mapX, ~] = eigs(L,D+1,'sm');
            mapX = mapX(:,2:end);
        case 'lle'
            % Local Linear Embedding
            mapX=lle(data',nn,D)';
        case 'isomap'
            % Isometric Mapping
            options.dims = D;
            options.display = 0;
            options.overlay = 0;
            A=pdist2(data,data);
            mapX = Isomap(A,'k', nn, options);
            mapX=mapX.coords{1,1}';
        case 'ltsa'
            % Local Tangent Space Alignment
            mapX=ltsa(data, D, nn);
        otherwise
            error('Valid methods include lap, lap_ad, lle, isomap, ltsa');
    end
end