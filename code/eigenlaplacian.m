function L = eigenlaplacian(DATA, options)
% Calculate the graph laplacian of the adjacency graph of data set DATA.
% L = eigenlaplacian(DATA, options)
% DATA - Nxd matrix. Data points are rows.
% options - Data structure containing the following fields
%   1. NN - number of nearest neighbors%
%   2. WEIGHTTYPPE='heat'|'ad_vpw'
%   3. WEIGHTPARAM= width for heat kernel
%   4. NORMALIZE= 0 | 1 whether to return normalized graph laplacian or not
% Returns: L, sparse symmetric NxN matrix

disp('Computing Graph Laplacian.');

NN=options.NN;
WEIGHTTYPE=options.GraphWeights;
WEIGHTPARAM=options.GraphWeightParam;
NORMALIZE=options.GraphNormalize;
if (~isfield(options, 'A'))
    disp('Computing weight matrix');
    [Idx, A_v]=knnsearch(DATA,DATA,'K',NN+1);
    A_v = A_v(:,2:end)';
    Idx = Idx(:,2:end)';
    Ad_i=(1:size(Idx,2))';
    Ad_i=repmat(Ad_i,1,NN)';
    Ad_i=Ad_i(:);
    Ad_j=Idx(:);
    Ad_v=A_v(:);
    A=sparse(Ad_i,Ad_j,Ad_v);
else
    A = options.A;
end
W = A;

% disassemble the sparse matrix
[A_i, A_j, A_v] = find(A);

switch WEIGHTTYPE
    case 'heat'
        disp(['Laplacian : Using Heat Kernel sigma : ' num2str(WEIGHTPARAM)]);
        t=WEIGHTPARAM;
        for i = 1: size(A_i)
            W(A_i(i), A_j(i)) = exp(-A_v(i)^2/(2*t*t));
        end

    case 'ad_vpw'
        disp('Laplacian : Using Heat Kernel ADAPTIVE sigma');
        j = 0;
        for i = 1:size(A_j)
            if (j~=A_j(i))
                j=A_j(i);
                if isfield(options, 'Ad_v') % if using some predefined bandwidth
                    t = options.Ad_v(j);
                else
                    t = max(A_v(A_j==j));   % Max distance in the neighborhood
                end
                t = t*length(find(j==A_j)); % NN of the neighborhood
            end
            W(A_i(i), A_j(i)) = exp(-A_v(i)^2/(2*t*t));
        end
    otherwise
        error('Unknown Weighttype');
end

W = (W+W')/2;
D = sum(W(:,:),2);

if NORMALIZE==0
    L = spdiags(D,0,speye(size(W,1)))-W;
else % normalized laplacian
    D=spdiags(sqrt(1./D),0,length(D),length(D));
    L=eye(size(W,1),'like',sparse(size(W,1),size(W,1),1))-D*W*D;
end
