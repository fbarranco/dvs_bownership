function [GO, GF] = cvGaborFilter2(I, gamma, lambda, b, theta, phi, shape, normalize);
% cvGaborFilter2 - 2D Gabor filter
%
% Synopsis
%   [GO GF] = cvGaborFilter2(I, gamma, lambda, b, theta, phi, [shape], [normalize])
%
% Description
%   The Gabor filter is basically a Gaussian, modulated by a complex sinusoid
%
% Inputs ([]s are optional)
%   (matrix) I        N x M matrix representing the input image
%   (scalar) gamma    The spatial aspect ratio, x to y.
%   (scalar) lambda   The wavelength of the sinusoidal function.
%   (scalar) b        The spatial frequency band-width (in octaves)
%   (scalar) theta    The orientation of the gabor filter.
%   (scalar) phi      The phase offset. 0 is the real parts of
%                     Gabor filter or even-symmetric, pi/2 is the
%                     imaginary parts of Gabor filter or odd-symmetric.
%   (string) [shape = 'reflect']
%                     The shape option for 2D convolution.
%                     In addition to 'full', 'same', and 'valid',
%                     'reflect' (reflected padding outside boundary) 
%                     is available. 
%   (enum)   [normalize = 'normsum']
%   - 'nonorm'   | 0  no normalization term
%   - 'normterm' | 1  apply normalization term
%   - 'normsum'  | 2  apply normalization to be sum becomes 1.0
%                     For the purpose of filtering, normalization term 
%                     is not necessary always.
%   (scalar) [sigma]  This is omitted. The standard deviation of 
%                     Gaussian and this determines the good size of window.
%                     This is automatically computed from lambda and b.
%
% Outputs ([]s are optional)
%    (matrix) GO      N x M matrix representing the output image
%    (matrix) [GF]    (2Sx+1) x (2Sy+1) matrix representing the Gabor filter
%                     where Sx = fix(sigma) and Sy = fix(sigma * gamma).

% References
%   [1] Gabor filter applet, http://www.cs.rug.nl/~imaging/simplecell.html
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
if isa(I, 'double') ~= 1
    I = double(I);
end

sigma = (1 / pi) * sqrt(log(2)/2) * (2^b+1) / (2^b-1) * lambda;
Sy = sigma * gamma;
for x = -fix(sigma):fix(sigma)
    for y = -fix(Sy):fix(Sy)
        xp = x * cos(theta) + y * sin(theta);
        yp = y * cos(theta) - x * sin(theta);
        yy = fix(Sy)+y+1;
        xx = fix(sigma)+x+1;
        GF(yy,xx) = exp(-.5*(xp^2+gamma^2*yp^2)/sigma^2) * cos(2*pi*xp/lambda+phi);
    end
end
if strcmp(normalize, 'normterm') | normalize == 1
    GF = GF ./ (2*pi*(sigma^2/gamma));
elseif strcmp(normalize, 'normsum') | normalize == 2
    GF = GF ./ sum(sum(GF));
end
GO = cvConv2(I, double(GF), shape);