function p = ssln2(b)
%SSLN2 Squared L2 Norm.
%   P = SSLN2(B);
%   input B must be N x 3;
%   output P is N x 1;

% Siyi Deng; 03-24-2011;
p = sum(b.*b,2);
end % SSLN2
