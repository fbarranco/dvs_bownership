function C = cvConv2(A, B, shape)
% cvConv2 - 2-D convolution
%
% Synopsis
%    C = cvConv2(A, B, [shape])
%
% Description
%   2-D convolution of matrix A and B. This is an extension of conv2.m
%   to support other options for boundary conditions. 
%
% Inputs ([]s are optional)
%   (matrix) A        ma x na matrix
%   (matrix) B        mb x nb matrix
%   (string) [shape = 'reflect']
%   - full            Returns the full two-dimensional convolution
%   - same            Returns the central part of the convolution of 
%                     the same size as A.
%   - valid           Returns only those parts of the convolution 
%                     that are computed without the zero-padded edges.
%   - reflect         Reflected padding outside boundary and 
%                     returns the same size as A.
%
% Outputs ([]s are optional)
%   (matrix) C        Output matrix. Size depends on shape option.
%
% See also
%   fspecial
%
% Requirements
%   conv2, cvuReflectBoundary

% Authors
%   Naotoshi Seo <sonots(at)sonots.com>
%
% License
%   The program is free to use.
%
% Changes
%   04/01/2006  First Edition
if ~exist('shape', 'var') || isempty(shape)
    shape = 'reflect';
end
if ndims(A) >= 3 || ndims(B) >= 3
    error('The 1st and 2nd inputs must be a two dimensional array.');
end
if strcmp(shape, 'reflect')
    A = cvuReflectBoundary(A, size(B));
    C = conv2(A, B, 'valid');
else
    C = conv2(A, B, shape);
end

% function C = icvConv2(A, B)
% % icvConv2 - Own implementation of 2-D convolution
% % Ignore outer space (eq. zero padding outside boundaries)
% [ma na] = size(A);
% [mb nb] = size(B);
% MaskRow = -floor(mb/2):ceil(mb/2-1);
% MaskCol = -floor(nb/2):ceil(nb/2-1);
% for n = 1:na
%      for m = 1:ma
%          M = m + MaskRow;
%          N = n + MaskCol;
%          mask = B(M >= 1 & M <= ma, N >= 1 & N <= na);
%          source = A(M(M >= 1 & M <= ma), N(N >= 1 & N <= na));
%          C(m, n) = sum(sum(source .* mask));
%      end
% end