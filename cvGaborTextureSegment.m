% cvGaborTextureSegment - Texture Segmentation using Gabor Filters
%
% Synopsis
%  Seg = cvGaborTextureSegment(I,K,Sx,Sy,F,Theta,FUN,Wx,Wy,sigma)
%
% Description
%  Unsupervised Texture Segmentation using Gabor Filters [1]
%
% Inputs ([]s are optional)
%  (matrix) I        N x M matrix representing the input image
%  (scalar) K        The number of expected segments.
%                    A parameter for K-means clustering.
%  (scalar) gamma    The spatial aspect ratio, x to y.
%  (scalar) lambda   The wavelength of the sinusoidal function.
%  (scalar) b        The spatial frequency band-width (in octaves)
%  (scalar) theta    The orientation of the gabor filter.
%  (scalar) phi      The phase offset. 0 is the real parts of
%                    Gabor filter or even-symmetric, pi/2 is the
%                    imaginary parts of Gabor filter or odd-symmetric.
%  (string) [shape = 'same']
%                    The shape option for conv2.m. See help conv2.
%
% Outputs ([]s are optional)
%  (matrix) Seg      N x M matrix containing the segmented image.
%                    Each element has its partition id.
%
% Requirements
%  cvGaborFilter2.m, cvGaussFilter2.m, cvKmeans.m
%
% References
% [1] Perona and Malik, "Preattentive texture discrimination with early 
% vision mechanisms," J. Opt. Soc. Am. A, Vol. 7, No. 5, May 1990 
% http://mplab.ucsd.edu/~marni/Igert/Malik_Perona_1990.pdf
% [2] A. K. Jain, F. Farrokhnia, "Unsupervised texture segmentation 
% using Gabor filters," Pattern Recognition, vol. 24, no. 12, pp.1167-1186, 1991
% [3] J.G. Daugman: Uncertainty relations for resolution in space, spatial 
% frequency, and orientation optimized by two-dimensional visual cortical 
% filters, Journal of the Optical Society of America A, 1985, vol. 2, pp. 1160-1169.
% [4] D. Clausi, M. Ed Jernigan, "Designing Gabor filters for optimal 
% texture separability, " Pattern Recognition, vol. 33, pp. 1835-1849, 2000.
% [5] P. Drodatz, "Textures: A Photographic lbum for Artists and 
% Desingers," Dover, Newe York, 1966. 
% http://www-dbv.informatik.uni-bonn.de/image/segmentation.html
% [6] Jianguo Zhang, Tieniu Tan, Li Ma, "Invariant texture segmentation 
% via circular gabor filter", Proceedings of the 16th IAPR International 
% Conference on Pattern Recognition (ICPR), Vol II, pp. 901-904, 2002. 
% http://www.dcs.qmul.ac.uk/~jgzhang/ICPR_857.pdf
% [7] Gabor filter applet. http://www.cs.rug.nl/~imaging/simplecell.html
% [8] Spatial filters - Gaussian Smoothing. 
% http://homepages.inf.ed.ac.uk/rbf/HIPR2/gsmooth.htm
% [9] Khaled Hammouda, "Texture Segmentation using Gabor Filters", 
% Course Project of SD775 at the University of Waterloo, 
% Ontario, Canada, May 2003, 
% http://pami.uwaterloo.ca/pub/hammouda/sd775-paper.pdf
%
% Authors
%  Naotoshi Seo <sonots(at)sonots.com>
%
% License
%  The program is free to use for non-commercial academic purposes,
%  but for course works, you must understand what is going inside to use.
%  The program can be used, modified, or re-distributed for any purposes
%  if you or one of your group understand codes (the one must come to
%  court if court cases occur.) Please contact the authors if you are
%  interested in using the program without meeting the above conditions.

% Changes
%  10/01/2006  First Edition
%function [Seg, O] = cvGaborTextureSegment(I, NK, gamma, Lambda, b, Theta, phi, shape)
function O = cvGaborTextureSegment(I, NK, gamma, Lambda, b, Theta, phi, shape)
[nRow, nCol, ~] = size(I);

% Step 1. Gabor Filter bank
ii = 0;

for lambda = Lambda
    for theta = Theta
        ii = ii + 1;
        D = cvGaborFilter2(I, gamma, lambda, b, theta, phi, shape, 0);
        % Normalize into [0, 1]
        D = D - min(D(:)); D = D / max(D(:));
        %figure; imshow(uint8(D * 255));
        % Adjust image size to the smallest size if 'valid' (Cut off)
        if (isequal(shape, 'valid') && ii >= 2)
            [nRow, nCol, ~] = size(O(:, :, ii-1));
            [Nr, Nc, ~] = size(D);
            DNr = (Nr - nRow)/2;
            DNc = (Nc - nCol)/2;
            D = D(1+floor(DNr):Nr-ceil(DNr), 1+floor(DNc):Nc-ceil(DNc));
        end
        O(:, :, ii) = D;
    end
end
[~, ~, N] = size(O);

% Step 2. Energy (Feature Extraction)
% Step 2-1. Nonlinearity
for ii=1:N
    D = O(:, :, ii);
    alpha = 1;
    D = tanh(double(O(:, :, ii)) .* alpha); % Eq. (3). Input is [0, 1]
    % Normalize into [0, 1] although output of tanh is originally [0, 1]
    D = D - min(D(:)); D = D / max(D(:));
    %figure; imshow(uint8(D * 255));
    O(:, :, ii) = D;
end

% Step 2-2. Smoothing

for ii=1:N
    D = O(:, :, ii);
    lambda = Lambda(floor((ii-1)/length(Theta))+1);
    % (1) constant
    % sigma = 5;
    % (2) Use lambda. 0.5 * lambda should be near equal to gabor's sigma
    % sigma = .5 * lambda;
    % (3). Use gabor's sigma
    sigma = (1 / pi) * sqrt(log(2)/2) * (2^b+1) / (2^b-1) * lambda;
    sigma = 3 * sigma;
    D = cvGaussFilter2(D, 2*fix(sigma)+1, sigma, shape, 0);  % Instead of Eq (4), Use Gaussian Filter
    % Normalize into [0, 1]
    D = D - min(D(:)); D = D / max(D(:));
    %figure; imshow(uint8(D * 255));
    % Adjust image size to the smallest size if 'valid' (Cut off)
    if (isequal(shape, 'valid') && ii >= 2)
        [nRow, nCol, C] = size(P(:, :, ii-1));
        [Nr, Nc, C] = size(D);
        DNr = (Nr - nRow)/2;
        DNc = (Nc - nCol)/2;
        D = D(1+floor(DNr):Nr-ceil(DNr), 1+floor(DNc):Nc-ceil(DNc));
    end
    P(:, :, ii) = D;
end
O = P;
%O = P; clear P;
%[nRow, nCol, N] = size(O);

% Step 3. Clustering
% Step 3-1. Adding coordinates information to involve adjacency
% [Oy, Ox] = meshgrid(1:nCol, 1:nRow);
% O(:,:,N+1) = Ox/nRow; O(:,:,N+2) = Oy/nCol;


% % for ii=1:nRow
% %     for jj=1:nCol
% %         O(ii, jj, N+1) = ii / nRow; % [0, 1]
% %         O(ii, jj, N+2) = jj / nCol;
% %     end
% % end
% 
% % Step 3-2. Clustering
% % keyboard
% data = reshape(O, [], size(O, 3)); % N x D
% % data = reshape(O, [], size(O, 3)).'; % D x N
% %[cluster, ~] = cvKmeans(data, K);
% %Seg = reshape(cluster, nRow, nCol, 1); % 2D
% 
% clust = zeros(size(data,1),numel(NK));
% for ii=1:numel(NK)
% clust(:,ii) = kmeans(data,NK(ii),'replicates',3);
% end
% eva = evalclusters(data,clust,'CalinskiHarabasz');
% index = (NK == eva.OptimalK);
% Seg = reshape(clust(:,index), nRow, nCol, 1); % 2D
% % keyboard
end