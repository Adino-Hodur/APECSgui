% Proprietary Algorithm and Software
% Version 1, Revised 01/05/2008
% Author:	Roman Rosipal, Ph. D.; rrosipal@pacdel.com
% (c) Pacific Development and Technology, LLC, 2007, 2008 www.pacdel.com

function pwrSpec = pwrSpecBlack(data)
%
w = window(@blackman, length(data));
windowedData = data .* w;
temp = 10*log10(abs(fft(windowedData)));
pwrSpec = temp(1 : length(data)/2);

%[pwrSpec,freq]=pwelch(data,w,[],[],256); 
%pwrSpec=pwrSpec(2:129); 