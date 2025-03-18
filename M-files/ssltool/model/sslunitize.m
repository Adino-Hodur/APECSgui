function y = sslunitize(x)
%SSLUNITIZE Normalize to have unit L2 norm for each row.
%   Y = SSLUNITIZE(X)

% Siyi Deng; 02-14-2011;

xn = sqrt(sum(abs(x).^2,2));
xn(xn == 0) = 1;
y = bsxfun(@rdivide,x,xn);
end % SSLUNITIZE;