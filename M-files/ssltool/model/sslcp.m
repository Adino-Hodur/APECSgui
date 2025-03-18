function c = sslcp(a,b)
%SSLCP Cross product.
%   C = SSLCP(A,B) is equivalent to CROSS(A,B) but saves some overhead. 
%   A and B must be coordinates in euclidean space;

% Siyi Deng; 09-26-2010;

c = zeros(size(a));
c(:,1) = a(:,2).*b(:,3)-a(:,3).*b(:,2);
c(:,2) = a(:,3).*b(:,1)-a(:,1).*b(:,3);
c(:,3) = a(:,1).*b(:,2)-a(:,2).*b(:,1); 
end % SSLCP;

