function [vx,vy]=fiit(mm, time, th1, th2)
% Generate some trivariate normal data for the example.  Two of
% the variables are correlated fairly strongly.
%X = mvnrnd([0 0 0], [1 .2 .7; .2 1 0; .7 0 1],50);
%load mm
%close all
% keyboard
[M,N]=size(mm);

% if (sum(sum((mm~=0)))> 4)
%     keyboard
% end

[XX,YY]=find(mm>0);
X=[];
% th1=1500;
for i=1:length(XX)
%     if abs(mm(XX(i),YY(i)) - time) <= th1   % We did this before, it's redundant
        X=[X; XX(i) YY(i) mm(XX(i),YY(i))];
%     end
end


% Next, fit a plane to the data using PCA.  The coefficients for the
% first two principal components define vectors that span the plane; the
% third PC is orthogonal to the first two, and its coefficients define the
% normal vector of the plane.
[coeff,score] = princomp(X);
coeff(:,1:2);
normal = coeff(:,3);

[n,p] = size(X);
meanX = mean(X,1);
Xfit = repmat(meanX,n,1) + score(:,1:2)*coeff(:,1:2)';
residuals = X - Xfit;

% The equation of the fitted plane is (x,y,z)*normal - meanX*normal = 0.
% The plane passes through the point meanX, and its perpendicular distance
% to the origin is meanX*normal. The perpendicular distance from each
% point to the plane, i.e., the norm of the residuals, is the dot product
% of each centered point with the normal to the plane.  The fitted plane
% minimizes the sum of the squared errors.
error = abs((X - repmat(meanX,n,1))*normal);
sse = sum(error.^2);
[XX,YY]=find(mm==0);



% Removing events whose distance to the fitted plane is > th
% X_cpy = X;
% th2 = 0.5;

X_cpy=[];

dist = X(:,1)*normal(1)+X(:,2)*normal(2)+X(:,3)*normal(3)-meanX*normal;

for i=1:size(X)
%     dist= X(i,1)*normal(1)+X(i,2)*normal(2)+X(i,3)*normal(3)-meanX*normal;
    if abs(dist(i)) <= th2
        X_cpy = [X_cpy; X(i,:)];
    end
end


% Computing the refined map
if size(X_cpy)>0
    [coeff,score] = princomp(X_cpy);
    normal = coeff(:,3);
    meanX = mean(X_cpy,1);
else
    normal = [0; 0; 0];
    meanX = [0 0 0];
end

%figure,plot3(X(:,1),X(:,2),X(:,3),'*r'),hold,plot3(Xfit(:,1),Xfit(:,2),Xfit(:,3),'ob')

%[xgrid,ygrid] = meshgrid(linspace(min(X(:,1)),max(X(:,1)),5), ...
%                         linspace(min(X(:,2)),max(X(:,2)),5));
                     
[xgrid,ygrid] = meshgrid(1:M,1:N);
zgrid = (1/normal(3)) .* (meanX*normal - (xgrid.*normal(1) + ygrid.*normal(2)));
%h = mesh(xgrid,ygrid,zgrid,'EdgeColor',[0 0 0],'FaceAlpha',0);



mm2=zeros(N,M);
for i=1:N
    for j=1:M
        mm2(xgrid(i,j),ygrid(i,j))=zgrid(i,j);
    end
end

if (norm(cross(normal,[0,1,0]))>.1)
    [vx,vy]=gradient(mm2);
    vx = 1./vx*1000; vy = 1./vy*1000; % In ms
else
    vx=0; vy=0;
end
