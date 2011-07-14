function [ HPD ] = HPDivergence(X, Y, options)
% 
% This function returns a characterization of the "separability" or
% divergence between the two data sets X and Y.  The
% calculation is based on:
%
% Friedman, J.H. and Rafsky, L.C. (1979). Multivariate Generalizations of
% the Wald-Wolfowitz and Smirnov Two-Sample Tests. The Annals of
% Statistics, Volume 7, 697-717. 
% Henze, N. and Penrose, M.D. (1999). On the Multivariate Runs Test. The
% Annals of Statistics, Volume 27, 290-298.
%
% Visar Berisha
% Last Update 5/17/2006

%**************************************************************************
% initialize and do checks

% get X, Y dimensions and number of samples
m = size(X, 1); % number of samples in first data set
n = size(Y, 1); % number of samples in second data set
dimX = size(X, 2); % number of features / measurements in first data set
dimY = size(Y, 2); % number of features / measurements in second data set
N = m + n; % total number of samples

% input data checks
if (n ~= m)
	fprintf(1,...
        ' CAUTION: The data sets have different numbers of samples: %6d, %6d\n', n, m);
    
end
if ( (dimY > n) | (dimX > m)) % more features than samples
	fprintf(1,...
        ' CAUTION: Are you sure the samples are in rows and the features are in columns?\n');
end
if (dimX ~= dimY)
	fprintf(1,' ERROR: The data sets have different dimensionalities.\n');
	return;
end

options.HenzePenrose.nTrees = 3;
options.HenzePenrose.pNorm = 2;
%**************************************************************************

%**************************************************************************
% form combined data set
dataXY = [X; Y];
% maintain class information
nodeX = -1*ones(m,1);
nodeY = ones(n,1);
nodeXY = [nodeX; nodeY];
%**************************************************************************

%**************************************************************************
% step 2: generate symmetric matrix of internode weights
weights = squareform(pdist(dataXY, 'minkowski', options.HenzePenrose.pNorm));
% generate a "large" weight, used to replace weights of edges already in
% listOfEdges as we step through the nTree MSTs
maxWeight = 10 * max(max(weights));
%**************************************************************************

%**************************************************************************
% determine the list of edges in the nTrees MSTs
listOfEdges = [];
currentMST = 0;
while (currentMST < options.HenzePenrose.nTrees)
    % get current set of MST edges
    [mstLength, currentListOfEdges] = mexMST(weights);
    
    % knock out these edges from future consideration for orthogonal MSTs
    for i=1:size(currentListOfEdges,1)
        weights(currentListOfEdges(i,1), currentListOfEdges(i,2)) = ...
            maxWeight;
        weights(currentListOfEdges(i,2), currentListOfEdges(i,1)) = ...
            maxWeight;
    end
   listOfEdges = [listOfEdges; currentListOfEdges];
   currentMST = currentMST + 1;
end
%**************************************************************************

%**************************************************************************
% Following Friedman&Rafsky p. 705, calculate:
% S = the number of edges deleted (i.e., how many of the edges in the
% nTrees MSTs have parent nodes from different datasets)
% E = number of edges in orthogonal MSTs
% C = number of edges that share a common node (see Friedman&Rafsky p. 709)
% P = 2mn((N)(N-1)

S = sum(nodeXY(listOfEdges(:,1)) ~= nodeXY(listOfEdges(:,2)));
E = size(listOfEdges, 1);
P = 2 * m * n / (N * (N-1));

C = 0;
for i=1:N
    degree = length(find(i == listOfEdges));
    C = C + degree * (degree-1);
end
C = C/2;
%**************************************************************************

%**************************************************************************
% calculate HPD
HPD = 1 - (S-1) / (N * options.HenzePenrose.nTrees);
 
