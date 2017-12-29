function Y = cvuReflectBoundary(X, msize)
% cvuReflectBoundary - (CV Utility) Reflect outside boundary. 
%
% Synopsis
%    Y = cvuReflectBoundary(X, msize)
%
% Description
%   This script extend a matrix by reflecting pixels inside boundaries
%   to outside boundaries so that 2-D convolution handles boundary 
%   conditions well. 
%
% Inputs ([]s are optional)
%   (matrix) X        M x N matrix
%   (vector) msize    1 x 2 vector representing mask size which determines
%                     how many pixels to be extended. 
%                     Let s1 = msize(1) and s2 = msize(2). 
%
% Outputs ([]s are optional)
%   (matrix) Y        (M+s1-1) x (N+s2-1) matrix containing the extended 
%                     matrix.
%
% Examples
%   I = imread('image/lena.png');
%   mask = fspecial('average', 3);
%   for c = 1:3
%       Y(:,:,c) = cvuReflectBoundary(I(:,:,c), size(mask));
%       O(:,:,c) = conv2(Y(:,:,c), mask, 'valid'); % gives same size with I.
%   end
%   imshow(uint8(O));
%
% See also
%   conv2
%
% Used by
%   cvConv2

% References
%   convolve.m by David Young
%   (http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=1289&objectType=File)
%
% Authors
%   Naotoshi Seo <sonots(at)sonots.com>
%
% License
%   The program is free to use.
%
% Changes
%   04/01/2006  First Edition
[mx, nx] = size(X);
mm = msize(1); nm = msize(2);
if mm > mx | nm > nx
    error('Mask does not fit inside array')
end

mo = floor((1+mm)/2); no = floor((1+nm)/2);  % reflected mask origin
ml = mo-1;            nl = no-1;             % mask left/above origin
mr = mm-mo;           nr = nm-no;            % mask right/below origin
me = mx-mr+1;         ne = nx-nr+1;          % translated margin in input
mt = mx+ml;           nt = nx+nl;            % top/right of image in output
my = mx+mm-1;         ny = nx+nm-1;          % output size

Y = zeros(my, ny);
Y(mo:mt, no:nt) = X;      % central region
if ml > 0
    Y(1:ml, no:nt) = X(ml:-1:1, :);                   % top side
    if nl > 0
        Y(1:ml, 1:nl) = X(ml:-1:1, nl:-1:1);          % top left corner
    end
    if nr > 0
        Y(1:ml, nt+1:ny) = X(ml:-1:1, nx:-1:ne);      % top right corner
    end
end
if mr > 0
    Y(mt+1:my, no:nt) = X(mx:-1:me, :);               % bottom side
    if nl > 0
        Y(mt+1:my, 1:nl) = X(mx:-1:me, nl:-1:1);      % bottom left corner
    end
    if nr > 0
        Y(mt+1:my, nt+1:ny) = X(mx:-1:me, nx:-1:ne);  % bottom right corner
    end
end
if nl > 0
    Y(mo:mt, 1:nl) = X(:, nl:-1:1);                   % left side
end
if nr > 0
    Y(mo:mt, nt+1:ny) = X(:, nx:-1:ne);               % right side
end
