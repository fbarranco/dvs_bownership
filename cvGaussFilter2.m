function [GO, GF] = cvGaussFilter2(I, wsize, Sigma, shape, normalize);
% cvGaussFilter2 - 2D Gaussian filter
%
% Synopsis
%   [GO GF] = cvGaussFilter2(I, wsize, Sigma, [shape], [normalize])
%
% Description
%   2-D Gaussian filter. 
%   fspecial('gaussian', wsize, sigma) supports only a scalar sigma, but 
%   this function supports 2 x 2 covariance matrix Sigma. 
%   fspecial normalizes the generated filter so that its sum becomes 1.0,
%   this function has other options for normalization. 
%   conv2(I, mask, 'same') padds outside boundaries with 0, but
%   this function supports to reflectly pad outside boundaries. 
%   This function supports color image input. 
%
% Inputs ([]s are optional)
%   (matrix) I        N x M x C matrix representing the input image
%   (vector) wsize    A scalar or 1 x 2 vector representing the size of
%   (scalar)          filter window. The number should be odd.
%                     A scalar specifies square window size.
%                     Let Wx = wsize(1), Wy = wsize(2).
%   (matrix) Sigma    A scalar or 2 x 2 matrix representing the standard 
%                     deviation or covariance matrix of 2-D Gaussian.
%                     A scalar composes a matrix [Sigma^2 0; 0 Sigma^2]
%                     Hint: Larger Sigma blurs more.
%   (string) [shape = 'reflect']
%                     The shape option for 2D convolution.
%                     In addition to 'full', 'same', and 'valid',
%                     'reflect' (reflected padding outside boundary) 
%                     is available. 
%   (enum)   [normalize = 'normsum']
%   - 'nonorm'   | 0  no normalization term
%   - 'normterm' | 1  apply normalization term (/ 2*pi*sqrt|Sigma|)
%   - 'normsum'  | 2  normalize to be sum becomes 1.0
%                     FYI: fspecial('gaussian') does 'normsum'. 
%
% Outputs ([]s are optional)
%   (matrix) GO       N x M x C matrix representing the output image
%   (matrix) [GF]     Wx x Wy matrix representing the Gaussian filter.
%
% See also
%   fspecial (Image Processing Toolbox), conv2, filter2
%
% Rquirements
%   cvGaussPdf, cvConv2 (requires conv2)

% References
%   [1] The 2-D Gaussian filter,
%   http://note.sonots.com/SciSoftware/GaussianFilter.html
%
% Authors
%   Naotoshi Seo <sonots(at)sonots.com>
%
% License
%   The program is free to use for non-commercial academic purposes,
%   but for course works, you must understand what is going inside to use.
%   The program can be used, modified, or re-distributed for any purposes
%   if you or one of your group understand codes (the one must come to
%   court if court cases occur.) Please contact the authors if you are
%   interested in using the program without meeting the above conditions.
%
% Changes
%   10/01/2006  First Edition
if ~exist('normalize', 'var') || isempty(normalize)
    normalize = 'normsum';
end
if ~exist('shape', 'var') || isempty(shape)
    shape = 'reflect';
end
if isscalar(Sigma)
    Sigma = [Sigma^2 0; 0 Sigma^2];
end
if isscalar(wsize)
    wysize = floor(wsize/2); wxsize = floor(wsize/2);
else
    wysize = floor(wsize(1)/2); wxsize = floor(wsize(2)/2);
end
if isa(I, 'double') ~= 1
    I = double(I);
end
[nRow, nCol, C] = size(I);

x = -wxsize:wxsize;
y = -wysize:wysize;
[X Y] = meshgrid(x, y);
Z = [reshape(X, [], size(X, 1) * size(X, 2));
    reshape(Y, [], size(Y, 1) * size(Y, 2))];
if strcmp(normalize, 'nonorm') | normalize == 0
    % no normalization
    GF = cvGaussPdf(Z, [0; 0], Sigma, 'nonorm', false);
elseif strcmp(normalize, 'normterm') | normalize == 1
    % gaussian normalization term
    GF = cvGaussPdf(Z, [0; 0], Sigma, 'normterm', false);
elseif strcmp(normalize, 'normsum') | normalize == 2
    % normalize so that sum becomes 1.0
    GF = cvGaussPdf(Z, [0; 0], Sigma, 'normsum', false);
    GF = GF ./ sum(GF);
end
GF = reshape(GF, size(X, 1), size(X, 2));
for c = 1:C
    GO(:,:,c) = cvConv2(I(:,:,c), GF, shape);
end