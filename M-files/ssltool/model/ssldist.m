function d = ssldist(a,b)
%SSLDIST Squared euclidean distance between two point sets.
%   D = SSLDIST(A,B) gives squared euclidean distance D for 
%   point sets A and B.

% Siyi Deng; 03-02-2011;

c = (mean(a,1)+mean(b,1))./2;
a = bsxfun(@minus,a,c);
b = bsxfun(@minus,b,c);
d = bsxfun(@plus,sum(a.^2,2),sum(b.^2,2).')-2*a*b.';
end % SSLDIST;


