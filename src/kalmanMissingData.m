% wrapper function for the kalman filter toolbox
% code by Fabian Benitez
%
%kalman filter with missing data
%input x=the observed data ( dimension by numberSamples), nan where missing
% 
%      t=the time data indicated wether or not the data is missing
% 
% 
%      A=The system matrix
%      H=the observation matrix
%      Q=system covariance
%      R=observation covariance

function [xOut]=kalmanMissingData(x,t,k)

[numDim tr]=size(x);
A=[eye(numDim) eye(numDim);zeros(numDim) eye(numDim)];
H=[eye(numDim) zeros(numDim)];
Q=eye(numDim*2)*k;

N=length(t);
idx=1;
idx2=1;
while idx<=N,    
    k1=0;
    while idx<=N && t(idx)==1 ,
        idx=idx+1;
        k1=k1+1;
    end
    if k1>=1,
        obs(idx2)=k1;
        idx2=idx2+1;
    end
    k1=0;
    while idx<=N && t(idx)<0,
        idx=idx+1;
        k1=k1+1;
    end
    if k1>=1,
        obs(idx2)=-k1;
        idx2=idx2+1;
    end
end

N2=length(obs);
if obs(1)>0,
    R=cov(x(:,1:obs(1))')+.0000001*eye(numDim);    
    [xfilt Vfilt]=kalman_filter(x(:,1:obs(1)),A,H,Q,R,[x(:,1);zeros(size(x(:,1)))],0);
    xPsObs=x(:,1:obs(1));
%     xobs=xfilt(1:numDim,:);
    for k1=2:N2,
        if obs(k1)<0,
            for k2=1:abs(obs(k1)),
                xTemp=A*xfilt(:,end);
                xfilt(:,end+1)=xTemp;
                xPsObs=[xPsObs xTemp(1:numDim)];
            end
        else
            [tr numObs]=size(xPsObs);
            xPsObs=[xPsObs x(:,numObs+1:numObs+obs(k1))];
            R=cov(xPsObs')+.0000001*eye(numDim);
            [xfilt Vfilt]=kalman_filter(xPsObs,A,H,Q,R,[xPsObs(:,1);zeros(size(x(:,1)))],0);            
        end        
    end
else
    x=fliplr(x);
    obs=fliplr(obs);
    R=cov(x(:,1:obs(1))')+.0000001*eye(numDim);    
    [xfilt Vfilt]=kalman_filter(x(:,1:obs(1)),A,H,Q,R,[x(:,1);zeros(size(x(:,1)))],0);
    xPsObs=x(:,1:obs(1));
%     xobs=xfilt(1:numDim,:);
    for k1=2:N2,
        if obs(k1)<0,
            for k2=1:abs(obs(k1)),
                xTemp=A*xfilt(:,end);
                xfilt(:,end+1)=xTemp;
                xPsObs=[xPsObs xTemp(1:numDim)];
            end
        else
            [tr numObs]=size(xPsObs);
            xPsObs=[xPsObs x(:,numObs+1:numObs+obs(k1))];
            R=cov(xPsObs')+.0000001*eye(numDim);
            
%             if sum(sum(isnan(R)))
%                 R
%             end
            
            [xfilt Vfilt]=kalman_filter(xPsObs,A,H,Q,R,[xPsObs(:,1);zeros(size(x(:,1)))],0);            
        end        
    end
    xPsObs=fliplr(xPsObs);
end
    
xfilt=kalman_smoother(xPsObs,A,H,Q,R,[x(:,1);zeros(size(x(:,1)))],0);
xOut=xfilt(1:numDim,:);

