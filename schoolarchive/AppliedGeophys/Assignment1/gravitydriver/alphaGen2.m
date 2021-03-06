function [alphaDat,alphaValue] = alphaGen2(G,WtW,W,D,Mref,n,tol)


% alphaDat{1} = alpha range
% alphaDat{2} = misfit
% alphaDat{3} = WNorm
% alphaDat{4} = count it took to find alpha
alphaDat{1} = 0;
alphaDat{2} = 0;
alphaDat{3} = 0;
alphaDat{4} = 0;



% Set up sigma two methods
%sigmaD = std(D); % Get standard deviation of data
sigmaD = 0.1*max(D);
SigN = sigmaD^2*n^2;
% Set up alpha

count = 1.5;
alpha = 10000;
MInv = (G*G' + alpha*(WtW))\(G*D + alpha*(WtW)*Mref);
A = (G'*MInv-D)'*(G'*MInv-D);
while  A > SigN + SigN*tol || A < SigN - SigN*tol
    if A > SigN + SigN*tol
        alpha = alpha - alpha/count;
        if count > 25
            alpha = 0.5*alpha;
            count = 1.1;
        end
    else
        alpha = alpha + alpha/count;
         if count > 25
            alpha = 1.5*alpha;
            count = 1.1;
        end
    end
    count = count +1;
    MInv = (G*G' + alpha*(WtW))\(G*D + alpha*(WtW)*Mref);
    A = (G'*MInv-D)'*(G'*MInv-D) ;
 
end
alphaValue = alpha;
 alphaDat{4} = count;  




%Get nice misfit curve

alphaDat{1} = logspace(-2,4,100);
alphaDat{2} = zeros(1,length(alphaDat{1}));
alphaDat{3} = zeros(1,length(alphaDat{1}));

for ii = 1: length(alphaDat{1})
    MInv = (G*G' + alphaDat{1}(ii).*(WtW))\(G*D +alphaDat{1}(ii).*(WtW)*Mref);
     alphaDat{2}(ii)=(G'*MInv-D)'*(G'*MInv-D);
     alphaDat{3}(ii) = ((W*MInv)'*(W*MInv));
end
end