function [DVSBO_res, ucmSeg]=detectDVSBOwnership(featRes, model, k)
% Detects, given the trained SRF model, and input DVS features, the
% border ownership predictons
% 
% USAGE
%   [DVSBO_res]=detectDVSBOwnership(featRes, model)
%
% INPUT
%   featRes     - [HxWxD] precomputed DVS features
%   model       - SRF DVS-BO model
%   k           - [0 1] threshold for ucm seg
%
% OUTPUT
%   DVSBO_res   - [HxW] DVS-BO predictions 
%   ucmSeg      - [HxW] initial UCM segmentation
%
% Ching L Teo, Feb 2015
%
% NO CHECKS HERE, for speed reasons
% NOTE: assume featRes has [~,~,dimF] == model.opts.nChns
[imR,imC,featDims]=size(featRes); sizOrig=[imR,imC];
assert(featDims==model.opts.nChns); shrink=model.opts.shrink;
model.opts.nTreesEval=8;          % for top speed set nTreesEval=1
model.opts.nThreads=8;            % max number threads for evaluation

r=model.opts.imWidth/2; p=[r r r r];
p([2 4])=p([2 4])+mod(4-mod(sizOrig(1:2)+2*r,4),4);
featResP = imPad(featRes,p,'symmetric'); % pad features

% smooth out feature channels
chnsReg=featResP; chnsSim=chnsReg;
chnSm=model.opts.chnSmooth/shrink; if(chnSm>1), chnSm=round(chnSm); end
simSm=model.opts.simSmooth/shrink; if(simSm>1), simSm=round(simSm); end
chnsReg=convTri(single(chnsReg),chnSm); chnsSim=convTri(single(chnsSim),simSm);

% predict BO
cd([pwd, '/models/private/']);
[Es, Efgs, Ebgs, EInd] = fgEdgesDetectMex(model,chnsReg,chnsSim);
cd('../..');
t=2*model.opts.stride^2/model.opts.gtWidth^2/model.opts.nTreesEval; 
r=model.opts.gtWidth/2;
Es=Es(1+r:sizOrig(1)+r,1+r:sizOrig(2)+r,:)*t; Es=convTri(Es,1);
Efgs=Efgs(1+r:sizOrig(1)+r,1+r:sizOrig(2)+r,:)*t; Efgs=convTri(Efgs,1);
Ebgs=Ebgs(1+r:sizOrig(1)+r,1+r:sizOrig(2)+r,:)*t; Ebgs=convTri(Ebgs,1);

% combine and return results 
DVSBO_res=cat(3,Es,Efgs,Ebgs);

% do ucm segmentation
gPbN=repmat(Es, [1 1 8]);       
ucm2 = contours2ucm_windows(gPbN, 'doubleSize');
ucm = ucm2(3:2:end, 3:2:end);
% get the boundaries of segmentation at scale k in range [0 1]
% k = 0.5; %img_t(i,2);
%bdry = (ucm >= k);
% get superpixels at scale k without boundaries:
labels2 = bwlabel(ucm2 <= k);
ucmSeg = labels2(2:2:end, 2:2:end); 

end