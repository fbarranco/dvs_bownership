% cvGaussPdf - Compute the PDF of a multivariate Gaussian
%
% Synopsis
%   Pr = cvGaussPdf(X, Mu, Sigma, normalize, logprob)
%
% Description
%   Computes the Probability Density Function (PDF) of a multivariate
%   Gaussian represented by means and covariance matrix.
%
% Inputs ([]s are optional)
%   (matrix) X        D x N matrix representing column feature vectors
%                     where D is the number of dimensions and N is the
%                     number of vectors.
%   (vector) Mu       D x 1 mean vector.
%   (matrix) Sigma    D x D covariance matrix. For example,
%                     for 1D gaussian, Sigma = [sigma^2], and
%                     for 2D, Sigma = [sx^2 sxy; sxy sy^2]. 
%   (enum)   [normalize = 'normterm']
%                     0 or 'nonorm' - Do not apply the normalization term
%                     1 or 'normterm' -  Apply the normalization term
%                         (/ ((2*pi)^(D/2) * sqrt|Sigma|) )
%                      2 or 'normsum' - Normalize so that prob sum bocomes 1
%   (enum)   [logprob = 0]
%                     0 - Return probabilities
%                     1 or 'logp' - Return log probabilities
%
% Outputs ([]s are optional)
%   (vector) Pr       1 x N probabilities.
%
% See also
%   cvMeanCov (Maximum Likelihood Estimator for Gaussian model)
%   mvnpdf (statistics toolbox), mvncdf (statistics toolbox)
%   pdf('norm',X,mu,sigma) (statistics toolbox)

% References
%   [1] http://en.wikipedia.org/wiki/Multivariate_Gaussian
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
%   04/01/2006  First Edition
function Pr = cvGaussPdf(X, Mu, Sigma, normalize, logprob)
if ~exist('normalize', 'var') || isempty(normalize)
    normalize = 'normterm';
end
if ~exist('logprob', 'var') || isempty(logprob)
    logprob = false;
end
[D, N] = size(X);
X = X - repmat(Mu, 1, N);
% Compute N points at burst
Pr = -0.5 * sum((X.' * inv(Sigma)) .* X.', 2) .';
%Pr = -0.5 * diag(X.' * inv(Sigma) * X); % slow
if strcmp(normalize, 'normterm') | normalize == 1
    normterm = log(2*pi)*(D/2) + (abs(det(Sigma))+realmin)*(1/2);
    Pr = Pr - normterm;
elseif strcmp(normalize, 'normsum') | normalize == 2
    Pr = Pr - max(Pr); % pre-normalization to avoid probs being all zero
    % by takin exp because of precision limit (necessary especially in C)
    Pr = Pr - log(sum(exp(Pr)));
end
if ~logprob, Pr = exp(Pr); end;
end